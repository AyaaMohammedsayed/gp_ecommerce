import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/product_model.dart';
import '../data/models/category_model.dart';
import '../data/api_service/api_service.dart';
import '../../../../core/auth_local_storage.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeApiService? apiService})
    : _apiService = apiService ?? HomeApiService(),
      super(HomeInitial());

  final HomeApiService _apiService;

  void loadHomeData() async {
    emit(HomeLoading());
    try {
      final token = AuthLocalStorage().getToken();
      final results = await Future.wait([
        _apiService.getCategories(token).catchError((_) => <CategoryModel>[]),
        _apiService.getProducts(token, page: 1).catchError((_) => <ProductModel>[]),
        _apiService.getOffers(token, page: 1).catchError((_) => <ProductModel>[]),
      ]);

      final categories = results[0] as List<CategoryModel>;
      final products = results[1] as List<ProductModel>;
      final offers = results[2] as List<ProductModel>;

      if (isClosed) return;
      if (categories.isEmpty && products.isEmpty && offers.isEmpty) {
        emit(HomeError(message: 'Failed to load data. Please check your connection.'));
        return;
      }
      
      emit(
        HomeLoaded(
          categories: categories,
          products: products,
          offers: offers,
          selectedCategory: '',
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        HomeError(
          message: 'Failed to load data. Please check your connection.',
        ),
      );
    }
  }

  Future<void> refreshHomeData() async {
    loadHomeData();
  }

  void selectCategory(String categoryName) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final category = currentState.categories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () =>
            const CategoryModel(id: -1, name: '', slug: '', coverImage: ''),
      );

      emit(currentState.copyWith(selectedCategory: categoryName));

      if (category.id != -1) {
        _loadCategoryProducts(category.id);
      }
    }
  }

  void _loadCategoryProducts(int categoryId) async {
    try {
      final token = AuthLocalStorage().getToken();
      final products = await _apiService.getProductsByCategory(token, categoryId);
      if (isClosed) return;
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(products: products));
      }
    } catch (_) {}
  }

  void loadAllProducts() async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: ''));
      try {
        final token = AuthLocalStorage().getToken();
        final products = await _apiService.getProducts(token, page: 1);
        if (isClosed) return;
        if (state is HomeLoaded) {
          emit((state as HomeLoaded).copyWith(products: products));
        }
      } catch (_) {}
    }
  }

  void toggleFavorite(String productId) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final id = int.tryParse(productId);
      if (id == null) return;

      final updatedProducts = currentState.products.map((p) {
        if (p.id == id) {
          return p.copyWith(isFavorite: !p.isFavorite);
        }
        return p;
      }).toList();
      emit(currentState.copyWith(products: updatedProducts));

      final token = AuthLocalStorage().getToken();
      _apiService.toggleFavorite(token, id).catchError((_) {});
    }
  }

  void searchProducts(String query) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void toggleShowAll() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showAll: !currentState.showAll));
    }
  }
}
