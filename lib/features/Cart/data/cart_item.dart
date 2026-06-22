import 'package:equatable/equatable.dart';

/// A single cart row, as returned by the API inside `GET /cart`'s `data` array.
///
/// Note the distinction between two different ids:
/// - [cartItemId] identifies the *cart row* — use this for PUT/DELETE on `/cart/{cart_item_id}`.
/// - [productId] identifies the *product* — use this for `POST /cart/add`.
class CartItemModel extends Equatable {
  final int cartItemId;
  final int quantity;
  final double subtotal;

  final int productId;
  final String name;
  final String? coverImage;
  final double price;
  final double? discountedPrice;
  final bool isOffer;

  const CartItemModel({
    required this.cartItemId,
    required this.quantity,
    required this.subtotal,
    required this.productId,
    required this.name,
    this.coverImage,
    required this.price,
    this.discountedPrice,
    this.isOffer = false,
  });

  /// Effective unit price (discounted if available, otherwise regular).
  double get effectivePrice => discountedPrice ?? price;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? const {};
    return CartItemModel(
      cartItemId: json['cart_item_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      productId: product['id'] ?? 0,
      name: product['name'] as String? ?? '',
      coverImage: product['cover_image'] as String?,
      price: (product['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (product['discounted_price'] as num?)?.toDouble(),
      isOffer: product['is_offer'] as bool? ?? false,
    );
  }

  CartItemModel copyWith({
    int? cartItemId,
    int? quantity,
    double? subtotal,
    int? productId,
    String? name,
    String? coverImage,
    double? price,
    double? discountedPrice,
    bool? isOffer,
  }) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      coverImage: coverImage ?? this.coverImage,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      isOffer: isOffer ?? this.isOffer,
    );
  }

  @override
  List<Object?> get props => [
        cartItemId,
        quantity,
        subtotal,
        productId,
        name,
        coverImage,
        price,
        discountedPrice,
        isOffer,
      ];
}