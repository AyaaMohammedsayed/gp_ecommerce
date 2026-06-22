import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeApiService {
  final http.Client _client;

  HomeApiService({http.Client? client})
    : _client = client ?? http.Client();

  Map<String, String> _headers(String? token) {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<CategoryModel>> getCategories(String? token) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Home Categories API Error: $e');
    }
  }

  Future<List<ProductModel>> getProducts(String? token, {int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}?page=$page');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Home Products API Error: $e');
    }
  }

  Future<List<ProductModel>> getOffers(String? token, {int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productOffers}?page=$page');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch offers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Home Offers API Error: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String? token, int categoryId, {int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoryProducts(categoryId)}?page=$page');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch category products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Home Category Products API Error: $e');
    }
  }

  Future<void> toggleFavorite(String? token, int productId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.toggleFavorite(productId)}');

    try {
      final response = await _client
          .post(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Home Toggle Favorite API Error: $e');
    }
  }
}
