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
        const CategoryModel(id: '1', name: 'Shoes', iconAsset: 'shoes'),
        const CategoryModel(id: '2', name: 'Clothes', iconAsset: 'clothes'),
        const CategoryModel(id: '3', name: 'Accessories', iconAsset: 'accessories'),
      ];

      final products = [
        const ProductModel(
          id: '1', 
          name: 'Nike Air Max', 
          price: 120.0, 
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', 
          category: 'Shoes'
        ),
        const ProductModel(
          id: '2', 
          name: 'Puma Runner', 
          price: 90.0, 
          imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5', 
          category: 'Shoes'
        ),
        const ProductModel(
          id: '3', 
          name: 'Adidas Pro', 
          price: 110.0, 
          imageUrl: 'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111', 
          category: 'Shoes'
        ),
        const ProductModel(
          id: '4', 
          name: 'Nike Air Force', 
          price: 150.0, 
          imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a', 
          category: 'Shoes'
        ),
        const ProductModel(
          id: '5', 
          name: 'Reebok Classic', 
          price: 85.0, 
          imageUrl: 'https://images.unsplash.com/photo-1539185441755-769473a23570', 
          category: 'Shoes'
        ),
        const ProductModel(
          id: '6', 
          name: 'Casual T-Shirt', 
          price: 25.0, 
          imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab', 
          category: 'Clothes'
        ),
        const ProductModel(
          id: '7', 
          name: 'Leather Jacket', 
          price: 200.0, 
          imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5', 
          category: 'Clothes'
        ),
        const ProductModel(
          id: '8', 
          name: 'Denim Jeans', 
          price: 60.0, 
          imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d', 
          category: 'Clothes'
        ),
      ];

      emit(HomeLoaded(categories: categories, products: products, selectedCategory: 'Shoes'));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void selectCategory(String categoryName) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: categoryName));
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
}
