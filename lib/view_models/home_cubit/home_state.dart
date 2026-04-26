part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final String selectedCategory;
  final String searchQuery;
  final bool showAll;

  const HomeLoaded({
    required this.categories,
    required this.products,
    required this.selectedCategory,
    this.searchQuery = '',
    this.showAll = false,
  });

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    String? selectedCategory,
    String? searchQuery,
    bool? showAll,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      showAll: showAll ?? this.showAll,
    );
  }

  @override
  List<Object?> get props => [categories, products, selectedCategory, searchQuery, showAll];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
