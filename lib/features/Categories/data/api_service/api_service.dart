import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gp_ecommerce/core/api_constants.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';

class CategoriesApiService {
  final http.Client _client;

  CategoriesApiService({http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<CategoriesResponseModel> getCategories(String token) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/categories');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CategoriesResponseModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      throw Exception('Categories API Error: $e');
    }
  }

  Future<CategoryModel> getCategoryDetails(
    String token,
    int categoryId,
  ) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/categories/$categoryId');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to fetch category details');
      }
    } catch (e) {
      throw Exception('Category Details API Error: $e');
    }
  }

  Future<ProductsResponseModel> getCategoryProducts(
    String token,
    int categoryId,
  ) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/categories/$categoryId/products');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to fetch category products');
      }
    } catch (e) {
      throw Exception('Category Products API Error: $e');
    }
  }
}