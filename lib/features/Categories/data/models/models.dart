class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String coverImage;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.coverImage,
  });

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      coverImage: json['cover_image'] ?? '',
    );
  }
}
class CategoriesResponseModel {
  final List<CategoryModel> data;

  CategoriesResponseModel({
    required this.data,
  });

  factory CategoriesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoriesResponseModel(
      data: (json['data'] as List? ?? [])
          .map(
            (e) => CategoryModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
class ProductModel {
  final int id;
  final String name;
  final String coverImage;
  final double price;
  final double discountedPrice;
  final bool isOffer;

  ProductModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.price,
    required this.discountedPrice,
    required this.isOffer,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coverImage: json['cover_image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountedPrice:
          (json['discounted_price'] ?? 0).toDouble(),
      isOffer: json['is_offer'] ?? false,
    );
  }
}
class PaginationLinksModel {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinksModel({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory PaginationLinksModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationLinksModel(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}
class PaginationMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationMetaModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
class ProductsResponseModel {
  final List<ProductModel> data;
  final PaginationLinksModel links;
  final PaginationMetaModel meta;

  ProductsResponseModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ProductsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductsResponseModel(
      data: (json['data'] as List? ?? [])
          .map(
            (e) => ProductModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      links: PaginationLinksModel.fromJson(
        json['links'] ?? {},
      ),
      meta: PaginationMetaModel.fromJson(
        json['meta'] ?? {},
      ),
    );
  }
}
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

  factory ProductDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountedPrice:
          (json['discounted_price'] ?? 0).toDouble(),
      isOffer: json['is_offer'] ?? false,
      images: List<String>.from(
        json['images'] ?? [],
      ),
      ratingStar:
          (json['rating_star'] ?? 0).toDouble(),
      showStock: json['show_stock'] ?? false,
      stock: json['stock'] ?? 0,
    );
  }
}