part of 'cubit.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProductModel> items;
  final Set<int> pendingProductIds;

  const FavoritesLoaded({
    required this.items,
    this.pendingProductIds = const {},
  });

  FavoritesLoaded copyWith({
    List<ProductModel>? items,
    Set<int>? pendingProductIds,
  }) {
    return FavoritesLoaded(
      items: items ?? this.items,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
    );
  }

  @override
  List<Object?> get props => [items, pendingProductIds];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError({required this.message});
  @override
  List<Object?> get props => [message];
}