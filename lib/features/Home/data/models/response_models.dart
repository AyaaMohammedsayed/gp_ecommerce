import 'category_model.dart';
import 'product_model.dart';
import 'pagination_models.dart';

class CategoriesResponseModel {
  final List<CategoryModel> data;

  CategoriesResponseModel({required this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      data: (json['data'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      data: (json['data'] as List? ?? [])
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: PaginationLinksModel.fromJson(json['links'] ?? {}),
      meta: PaginationMetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}
