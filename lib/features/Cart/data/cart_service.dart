import '../../../core/api_client.dart';
import '../../../core/constants/api_constants.dart';
import 'cart_item.dart';


/// Result of `GET /cart`: items + server-calculated totals.
class CartResponse {
  final List<CartItemModel> items;
  final double cartTotal;
  final int itemCount;
  const CartResponse({
    required this.items,
    required this.cartTotal,
    required this.itemCount,
  });
}

/// Service layer for Cart API calls.
///
/// Uses [ApiClient], which already attaches the auth header and throws
/// [ApiException] (carrying the API's own `msg`/`message`) on non-2xx
/// responses — so callers (the cubit) get the real backend error for free.
class CartService {
  final ApiClient _client = ApiClient();

  /// Fetches the current user's cart with computed subtotals + total.
  Future<CartResponse> getCart() async {
    final response = await _client.get(ApiConstants.cart);
    final List<dynamic> data = response['data'] as List<dynamic>? ?? [];
    final meta = response['meta'] as Map<String, dynamic>? ?? const {};
    return CartResponse(
      items: data
          .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      cartTotal: (meta['cart_total'] as num?)?.toDouble() ?? 0.0,
      itemCount: meta['item_count'] as int? ?? 0,
    );
  }

  /// Adds [productId] to the cart. If already present, the backend
  /// increments its quantity instead of duplicating the row.
  Future<void> addToCart(int productId, {int quantity = 1}) async {
    await _client.post(
      ApiConstants.cartAdd,
      body: {'product_id': productId, 'quantity': quantity},
    );
  }

  /// Sets the exact quantity for a cart row.
  /// NOTE: [cartItemId] is the cart row id from `GET /cart`, not the product id.
  Future<void> updateQuantity(int cartItemId, int quantity) async {
    await _client.put(
      ApiConstants.cartItem(cartItemId),
      body: {'quantity': quantity},
    );
  }

  /// Removes a single row from the cart.
  Future<void> removeItem(int cartItemId) async {
    await _client.delete(ApiConstants.cartItem(cartItemId));
  }

  /// Empties the entire cart.
  Future<void> clearCart() async {
    await _client.delete(ApiConstants.cart);
  }
}