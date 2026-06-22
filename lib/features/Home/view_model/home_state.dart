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
  final List<ProductModel> offers;
  final String selectedCategory;
  final String searchQuery;
  final bool showAll;

  const HomeLoaded({
    required this.categories,
    required this.products,
    this.offers = const [],
    required this.selectedCategory,
    this.searchQuery = '',
    this.showAll = false,
  });

  /// Returns products filtered by the current search query.
  List<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    final query = searchQuery.toLowerCase();
    return products
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
  }

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? offers,
    String? selectedCategory,
    String? searchQuery,
    bool? showAll,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      offers: offers ?? this.offers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      showAll: showAll ?? this.showAll,
    );
  }

  @override
  List<Object?> get props =>
      [categories, products, offers, selectedCategory, searchQuery, showAll];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
