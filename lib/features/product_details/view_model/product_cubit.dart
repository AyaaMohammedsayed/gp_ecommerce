import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetic/features/product_details/data/api_service.dart';
import 'package:kinetic/features/product_details/view_model/product_states.dart';
import '../../Home/data/models/response_models.dart';
import '../../Home/data/models/product_details_model.dart';


class ProductsCubit extends Cubit<ProductsState> {
  final ProductsApiService _dataSource;

  ProductsCubit({
    ProductsApiService? dataSource,
  })  : _dataSource = dataSource ?? ProductsApiService(),
        super(ProductsInit());

  ProductsResponseModel? productsResponse;
  ProductsResponseModel? offersResponse;
  ProductDetailsModel? productDetails;

  Future<void> getProducts(String? accessToken) async {
    emit(GetProductsLoading());

    try {
      final response =
          await _dataSource.getProducts(
        accessToken,
      );

      productsResponse = response;

      emit(
        GetProductsSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GetProductsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getOffers(String? accessToken) async {
    emit(GetOffersLoading());

    try {
      final response =
          await _dataSource.getOffers(
        accessToken,
      );

      offersResponse = response;

      emit(
        GetOffersSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GetOffersError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getProductDetails(String? accessToken, int productId) async {
    productDetails = null;
    emit(
      GetProductDetailsLoading(),
    );

    try {
      final response =
          await _dataSource.getProductDetails(
        accessToken,
        productId,
      );

      productDetails = response;

      emit(
        GetProductDetailsSuccess(
          response,
        ),
      );
    } catch (e) {
      emit(
        GetProductDetailsError(
          e.toString(),
        ),
      );
    }
  }
}
