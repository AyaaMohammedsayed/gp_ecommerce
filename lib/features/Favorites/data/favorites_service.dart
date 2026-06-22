import '../../../core/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../Home/data/models/product_model.dart';
import '../../Home/data/models/pagination_models.dart';
import 'package:flutter/foundation.dart';

class FavoritesResponse {
  final List<ProductModel> items;
  final PaginationMetaModel meta;
  const FavoritesResponse({required this.items, required this.meta});
}

class FavoritesService {
  final ApiClient _client = ApiClient();

  Future<FavoritesResponse> getFavorites({int page = 1}) async {
    final response = await _client.get(
      ApiConstants.favorites,
      queryParams: {'page': page.toString()},
    );
    debugPrint('getFavorites response: $response');
    final List<dynamic> data = response['data'] as List<dynamic>? ?? [];
    return FavoritesResponse(
      items: data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      meta: PaginationMetaModel.fromJson(response['meta'] ?? {}),
    );
  }

  /// Returns the new favorite state from the server (true = now favorited).
  Future<bool> toggleFavorite(int productId) async {
    final response = await _client.post(ApiConstants.toggleFavorite(productId));
    return response['is_favorite'] as bool? ?? false;
  }
}