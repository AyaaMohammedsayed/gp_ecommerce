import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_ecommerce/features/Categories/data/api_service/api_service.dart';
import 'package:gp_ecommerce/features/Categories/data/models/models.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_states.dart';



class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesApiService _dataSource;

  CategoriesCubit({
    CategoriesApiService? dataSource,
  })  : _dataSource = dataSource ?? CategoriesApiService(),
        super(CategoriesInit());

  CategoriesResponseModel? categoriesResponse;
  CategoryModel? categoryDetails;
  ProductsResponseModel? categoryProductsResponse;

  Future<void> getCategories(
    String accessToken,
  ) async {
    emit(GetCategoriesLoading());

    try {
      final response =
          await _dataSource.getCategories(
        accessToken,
      );

      categoriesResponse = response;

      emit(GetCategoriesSuccess(response));
    } catch (e) {
      emit(
        GetCategoriesError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getCategoryDetails(
    String accessToken,
    int categoryId,
  ) async {
    emit(GetCategoryDetailsLoading());

    try {
      final response =
          await _dataSource.getCategoryDetails(
        accessToken,
        categoryId,
      );

      categoryDetails = response;

      emit(
        GetCategoryDetailsSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GetCategoryDetailsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getCategoryProducts(
    String accessToken,
    int categoryId,
  ) async {
    emit(GetCategoryProductsLoading());

    try {
      final response =
          await _dataSource.getCategoryProducts(
        accessToken,
        categoryId,
      );

      categoryProductsResponse = response;

      emit(
        GetCategoryProductsSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GetCategoryProductsError(
          e.toString(),
        ),
      );
    }
  }
}