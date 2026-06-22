class ProductDetailsModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final bool isOffer;
  final List<String> images;
  final double ratingStar;
  final bool showStock;
  final int stock;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.isOffer,
    required this.images,
    required this.ratingStar,
    required this.showStock,
    required this.stock,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountedPrice: (json['discounted_price'] ?? 0).toDouble(),
      isOffer: json['is_offer'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      ratingStar: (json['rating_star'] ?? 0).toDouble(),
      showStock: json['show_stock'] ?? false,
      stock: json['stock'] ?? 0,
    );
  }
}
