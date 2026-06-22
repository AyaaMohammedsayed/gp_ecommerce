part of 'cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double cartTotal;
  final int itemCount;

  /// IDs of cart rows currently being mutated (quantity change / remove)
  /// so the UI can show a small inline spinner instead of a full reload.
  final Set<int> pendingItemIds;

  const CartLoaded({
    required this.items,
    required this.cartTotal,
    required this.itemCount,
    this.pendingItemIds = const {},
  });

  CartLoaded copyWith({
    List<CartItemModel>? items,
    double? cartTotal,
    int? itemCount,
    Set<int>? pendingItemIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      cartTotal: cartTotal ?? this.cartTotal,
      itemCount: itemCount ?? this.itemCount,
      pendingItemIds: pendingItemIds ?? this.pendingItemIds,
    );
  }

  @override
  List<Object?> get props => [items, cartTotal, itemCount, pendingItemIds];
}

/// Carries the *exact* message the backend returned (via [ApiException]),
/// instead of a generic hardcoded string.
class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Emitted briefly after a successful "Add to Cart" so the UI (e.g. the
/// product details screen) can show a confirmation snackbar via BlocListener.
class CartItemAdded extends CartState {
  final int productId;

  const CartItemAdded({required this.productId});

  @override
  List<Object?> get props => [productId];
}