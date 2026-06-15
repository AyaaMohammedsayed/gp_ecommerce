import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../data/home_service.dart';
import '../../../core/api_client.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeService? homeService})
      : _homeService = homeService ?? HomeService(),
        super(HomeInitial());

  final HomeService _homeService;

  void loadHomeData() async {
    emit(HomeLoading());
    try {
      // Fetch categories and products from the backend in parallel
      final results = await Future.wait([
        _homeService.getCategories(),
        _homeService.getProducts(page: 1),
      ]);

      final categories = results[0] as List<CategoryModel>;
      final products = results[1] as List<ProductModel>;

      emit(HomeLoaded(
        categories: categories,
        products: products,
        selectedCategory: '',
      ));
    } on ApiException catch (e) {
      emit(HomeError(message: 'Server error: ${e.message}'));
    } catch (e) {
      emit(HomeError(message: 'Failed to load data. Please check your connection.'));
    }
  }

  void selectCategory(String categoryName) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      // Find the category by name to get its ID
      final category = currentState.categories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => const CategoryModel(id: -1, name: '', slug: '', coverImage: ''),
      );

      emit(currentState.copyWith(selectedCategory: categoryName));

      // Load products filtered by this category from the API
      if (category.id != -1) {
        _loadCategoryProducts(category.id, currentState);
      }
    }
  }

  void _loadCategoryProducts(int categoryId, HomeLoaded currentState) async {
    try {
      final products = await _homeService.getProductsByCategory(categoryId);
      // Only update if still on the same state
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(products: products));
      }
    } catch (_) {
      // Silently fail — keep showing existing products
    }
  }

  void loadAllProducts() async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: ''));
      try {
        final products = await _homeService.getProducts(page: 1);
        if (state is HomeLoaded) {
          emit((state as HomeLoaded).copyWith(products: products));
        }
      } catch (_) {
        // Keep existing products
      }
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
