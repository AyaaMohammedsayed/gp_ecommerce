import 'package:gp_ecommerce/features/Categories/data/models/models.dart';

abstract class ProductsState {}

class ProductsInit extends ProductsState {}

class GetProductsLoading extends ProductsState {}

class GetProductsSuccess extends ProductsState {
  final ProductsResponseModel response;

  GetProductsSuccess(this.response);
}

class GetProductsError extends ProductsState {
  final String error;

  GetProductsError(this.error);
}

class GetOffersLoading extends ProductsState {}

class GetOffersSuccess extends ProductsState {
  final ProductsResponseModel response;

  GetOffersSuccess(this.response);
}

class GetOffersError extends ProductsState {
  final String error;

  GetOffersError(this.error);
}

class GetProductDetailsLoading extends ProductsState {}

class GetProductDetailsSuccess extends ProductsState {
  final ProductDetailsModel response;

  GetProductDetailsSuccess(this.response);
}

class GetProductDetailsError extends ProductsState {
  final String error;

  GetProductDetailsError(this.error);
}