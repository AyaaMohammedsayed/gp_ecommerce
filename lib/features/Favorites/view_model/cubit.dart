import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data.dart';


part 'states.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit(this.repository) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    try {
      await repository.removeFavorite(productId);
      emit(FavoritesRemoved(productId));
      await loadFavorites(); // تحديث القائمة
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      await repository.addToCart(product);
      // ممكن تظهري رسالة نجاح
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}