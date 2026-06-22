import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../Home/data/models/response_models.dart';
import '../../Home/data/models/product_details_model.dart';

class ProductsApiService {
  final http.Client _client;

  ProductsApiService({http.Client? client}) : _client = client ?? http.Client();

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

  Future<ProductsResponseModel> getProducts(String? token) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}');

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

  Future<ProductsResponseModel> getOffers(String? token) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productOffers}');

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
    String? token,
    int productId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.productDetails(productId)}',
    );

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
