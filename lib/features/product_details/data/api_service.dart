import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gp_ecommerce/core/api_constants.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';

class ProductsApiService {
  final http.Client _client;

  ProductsApiService({http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ProductsResponseModel> getProducts(String token) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/products');

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
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Products API Error: $e');
    }
  }

  Future<ProductsResponseModel> getOffers(String token) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/products/offers');

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
        throw Exception('Failed to fetch offers');
      }
    } catch (e) {
      throw Exception('Offers API Error: $e');
    }
  }

  Future<ProductDetailsModel> getProductDetails(
    String token,
    int productId,
  ) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/products/$productId');

    try {
      final response = await _client
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 15));

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ProductDetailsModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Product Details API Error: $e');
    }
  }
}