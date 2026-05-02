import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      
      final categories = [
        const CategoryModel(id: '1', name: 'Watch', iconAsset: 'watch'),
        const CategoryModel(id: '2', name: 'Phone', iconAsset: 'phone'),
        const CategoryModel(id: '3', name: 'Audio', iconAsset: 'audio'),
      ];

      final products = [
        const ProductModel(
          id: '1', 
          name: 'PRO-LAB 14"', 
          price: 1399.00, 
          imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853', 
          category: 'Phone' 
        ),
        const ProductModel(
          id: '2', 
          name: 'XAMOX V1', 
          price: 450.0, 
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30', 
          category: 'Watch'
        ),
        const ProductModel(
          id: '3', 
          name: 'HEX 16', 
          price: 899.0, 
          imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9', 
          category: 'Phone'
        ),
      ];

      emit(HomeLoaded(categories: categories, products: products, selectedCategory: 'Watch'));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void selectCategory(String categoryName) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: categoryName, showAll: false));
    }
  }

  void toggleFavorite(String productId) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedProducts = currentState.products.map((p) {
        if (p.id == productId) {
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
