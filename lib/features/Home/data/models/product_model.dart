import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final double price;
  final double? discountedPrice;
  final bool isOffer;
  final String coverImage;
  final String? description;
  final List<String> images;
  final double ratingStar;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
    this.isOffer = false,
    required this.coverImage,
    this.description,
    this.images = const [],
    this.ratingStar = 0.0,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      isOffer: json['is_offer'] as bool? ?? false,
      coverImage: json['cover_image'] as String? ?? '',
      description: json['description'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : const [],
      ratingStar: (json['rating_star'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    double? discountedPrice,
    bool? isOffer,
    String? coverImage,
    String? description,
    List<String>? images,
    double? ratingStar,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      isOffer: isOffer ?? this.isOffer,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      images: images ?? this.images,
      ratingStar: ratingStar ?? this.ratingStar,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Returns the effective price (discounted if available, otherwise regular).
  double get effectivePrice => discountedPrice ?? price;

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        discountedPrice,
        isOffer,
        coverImage,
        description,
        images,
        ratingStar,
        isFavorite,
      ];
}
