import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/api_client.dart';
import '../data/cart_item.dart';
import '../data/cart_service.dart';

part 'states.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({CartService? cartService})
      : _cartService = cartService ?? CartService(),
        super(CartInitial());

  final CartService _cartService;

  /// Loads the cart from the API.
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final response = await _cartService.getCart();
      if (isClosed) return;
      emit(
        CartLoaded(
          items: response.items,
          cartTotal: response.cartTotal,
          itemCount: response.itemCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      // Surface the API's own message (e.g. ApiException.message) rather
      // than a hardcoded one, so the user/dev sees exactly what went wrong.
      emit(CartError(message: _extractMessage(e)));
    }
  }

  Future<void> refreshCart() => loadCart();

  /// Adds a product to the cart, then refreshes so totals stay accurate.
  Future<void> addToCart(int productId, {int quantity = 1}) async {
    try {
      await _cartService.addToCart(productId, quantity: quantity);
      if (isClosed) return;
      emit(CartItemAdded(productId: productId));
      await loadCart();
    } catch (e) {
      if (isClosed) return;
      emit(CartError(message: _extractMessage(e)));
    }
  }

  /// Sets the exact quantity for [cartItemId].
  /// Updates the UI immediately (optimistic), then confirms with the API.
  /// On failure, reloads the real cart state from the server.
  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity < 1) return;
    final current = state;
    if (current is! CartLoaded) return;

    final index = current.items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index == -1) return;

    final oldItem = current.items[index];
    final unitPrice = oldItem.effectivePrice;
    final updatedItem = oldItem.copyWith(
      quantity: newQuantity,
      subtotal: unitPrice * newQuantity,
    );

    final updatedItems = List<CartItemModel>.from(current.items);
    updatedItems[index] = updatedItem;
    final newTotal = updatedItems.fold<double>(0, (sum, i) => sum + i.subtotal);

    emit(
      current.copyWith(
        items: updatedItems,
        cartTotal: newTotal,
        pendingItemIds: {...current.pendingItemIds, cartItemId},
      ),
    );

    try {
      await _cartService.updateQuantity(cartItemId, newQuantity);
      if (isClosed) return;
      final after = state;
      if (after is CartLoaded) {
        emit(
          after.copyWith(
            pendingItemIds: after.pendingItemIds
                .where((id) => id != cartItemId)
                .toSet(),
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      // Roll back to the server's real state and surface the real error.
      emit(CartError(message: _extractMessage(e)));
      await loadCart();
    }
  }

  void incrementQuantity(int cartItemId) {
    final current = state;
    if (current is! CartLoaded) return;
    final item = current.items.firstWhere(
      (i) => i.cartItemId == cartItemId,
      orElse: () => const CartItemModel(
        cartItemId: -1,
        quantity: 0,
        subtotal: 0,
        productId: -1,
        name: '',
        price: 0,
      ),
    );
    if (item.cartItemId == -1) return;
    updateQuantity(cartItemId, item.quantity + 1);
  }

  void decrementQuantity(int cartItemId) {
    final current = state;
    if (current is! CartLoaded) return;
    final item = current.items.firstWhere(
      (i) => i.cartItemId == cartItemId,
      orElse: () => const CartItemModel(
        cartItemId: -1,
        quantity: 0,
        subtotal: 0,
        productId: -1,
        name: '',
        price: 0,
      ),
    );
    if (item.cartItemId == -1 || item.quantity <= 1) return;
    updateQuantity(cartItemId, item.quantity - 1);
  }

  /// Removes a row from the cart (optimistic removal + API confirmation).
  Future<void> removeItem(int cartItemId) async {
    final current = state;
    if (current is! CartLoaded) return;

    final removedItem = current.items.firstWhere(
      (i) => i.cartItemId == cartItemId,
      orElse: () => const CartItemModel(
        cartItemId: -1,
        quantity: 0,
        subtotal: 0,
        productId: -1,
        name: '',
        price: 0,
      ),
    );
    if (removedItem.cartItemId == -1) return;

    final updatedItems =
        current.items.where((i) => i.cartItemId != cartItemId).toList();
    final newTotal = updatedItems.fold<double>(0, (sum, i) => sum + i.subtotal);

    emit(
      current.copyWith(
        items: updatedItems,
        cartTotal: newTotal,
        itemCount: updatedItems.length,
      ),
    );

    try {
      await _cartService.removeItem(cartItemId);
    } catch (e) {
      if (isClosed) return;
      // Put the item back and surface the real error — don't silently
      // pretend the removal succeeded if the backend rejected it.
      emit(CartError(message: _extractMessage(e)));
      await loadCart();
    }
  }

  /// Empties the cart.
  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      if (isClosed) return;
      emit(const CartLoaded(items: [], cartTotal: 0, itemCount: 0));
    } catch (e) {
      if (isClosed) return;
      emit(CartError(message: _extractMessage(e)));
    }
  }

  /// Pulls the real backend message out of [ApiException], falling back
  /// to the exception's own toString() for anything unexpected
  /// (timeouts, no internet, parsing errors, etc).
  String _extractMessage(Object e) {
    if (e is ApiException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}