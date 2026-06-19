import '../../Home/data/models/category_model.dart';
import '../../Home/data/models/response_models.dart';

abstract class CategoriesState {}

class CategoriesInit extends CategoriesState {}

class GetCategoriesLoading extends CategoriesState {}

class GetCategoriesSuccess extends CategoriesState {
  final CategoriesResponseModel response;

  GetCategoriesSuccess(this.response);
}

class GetCategoriesError extends CategoriesState {
  final String error;

  GetCategoriesError(this.error);
}

class GetCategoryDetailsLoading extends CategoriesState {}

class GetCategoryDetailsSuccess extends CategoriesState {
  final CategoryModel response;

  GetCategoryDetailsSuccess(this.response);
}

class GetCategoryDetailsError extends CategoriesState {
  final String error;

  GetCategoryDetailsError(this.error);
}

class GetCategoryProductsLoading extends CategoriesState {}

class GetCategoryProductsSuccess extends CategoriesState {
  final ProductsResponseModel response;

  GetCategoryProductsSuccess(this.response);
}

class GetCategoryProductsError extends CategoriesState {
  final String error;

  GetCategoryProductsError(this.error);
}