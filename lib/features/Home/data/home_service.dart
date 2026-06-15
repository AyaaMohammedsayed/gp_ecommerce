import '../../../core/api_client.dart';
import '../../../core/api_constants.dart';
import 'models/category_model.dart';
import 'models/product_model.dart';

/// Service layer for Home Page API calls.
class HomeService {
  final ApiClient _client = ApiClient();

  /// Fetches all categories from the backend.
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get(ApiConstants.categories);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetches paginated products from the backend.
  Future<List<ProductModel>> getProducts({int page = 1}) async {
    final response = await _client.get(
      ApiConstants.products,
      queryParams: {'page': page.toString()},
    );
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetches products with special offers.
  Future<List<ProductModel>> getOffers({int page = 1}) async {
    final response = await _client.get(
      ApiConstants.productOffers,
      queryParams: {'page': page.toString()},
    );
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetches products belonging to a specific category.
  Future<List<ProductModel>> getProductsByCategory(int categoryId,
      {int page = 1}) async {
    final response = await _client.get(
      ApiConstants.categoryProducts(categoryId),
      queryParams: {'page': page.toString()},
    );
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
