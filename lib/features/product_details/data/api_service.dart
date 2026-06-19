import 'dart:convert';

import 'package:gp_ecommerce/core/api_constants.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsApiService {
  Future getProducts(
    String accessToken,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/products',
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
          'Failed to Get Products: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Products: $e',
      );
    }
  }

  Future getOffers(
    String accessToken,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/products/offers',
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
          'Failed to Get Offers: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Offers: $e',
      );
    }
  }

  Future getProductDetails(
    String accessToken,
    int productId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/products/$productId',
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

        return ProductDetailsModel.fromJson(
          json['data'],
        );
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please check your access token.',
        );
      } else {
        throw Exception(
          'Failed to Get Product Details: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error Getting Product Details: $e',
      );
    }
  }
}