import 'dart:convert';

import 'package:gp_ecommerce/core/api_constants.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';
import 'package:http/http.dart' as http;

class CategoriesApiService {
  Future getCategories(String accessToken) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}categories/',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CategoriesResponseModel.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please check your access token.',
        );
      } else {
        throw Exception(
          'Failed to Get Categories: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Categories: $e',
      );
    }
  }

  Future getCategoryDetails(
    String accessToken,
    int categoryId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/categories/$categoryId',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return CategoryModel.fromJson(
          json['data'],
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please check your access token.',
        );
      } else {
        throw Exception(
          'Failed to Get Category Details: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Category Details: $e',
      );
    }
  }

  Future getCategoryProducts(
    String accessToken,
    int categoryId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/categories/$categoryId/products',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return ProductsResponseModel.fromJson(
          json,
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please check your access token.',
        );
      } else {
        throw Exception(
          'Failed to Get Category Products: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Category Products: $e',
      );
    }
  }
}