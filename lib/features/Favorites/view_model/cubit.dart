import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/api_client.dart';
import '../../Home/data/models/product_model.dart';
import '../data/favorites_service.dart';

part 'states.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({FavoritesService? service})
      : _service = service ?? FavoritesService(),
        super(FavoritesInitial());

  final FavoritesService _service;

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final response = await _service.getFavorites();
      if (isClosed) return;
      emit(FavoritesLoaded(items: response.items));
    } catch (e) {
      if (isClosed) return;
      emit(FavoritesError(message: _extractMessage(e)));
    }
  }

  Future<void> refreshFavorites() => loadFavorites();

  /// Optimistically removes the product from the list, confirms with the
  /// API, and rolls back (reloading the real list) if the call fails.
  Future<void> toggleFavorite(int productId) async {
    final current = state;
    if (current is! FavoritesLoaded) return;

    final updatedItems =
        current.items.where((p) => p.id != productId).toList();

    emit(current.copyWith(
      items: updatedItems,
      pendingProductIds: {...current.pendingProductIds, productId},
    ));

    try {
      await _service.toggleFavorite(productId);
      if (isClosed) return;
      final after = state;
      if (after is FavoritesLoaded) {
        emit(after.copyWith(
          pendingProductIds:
              after.pendingProductIds.where((id) => id != productId).toSet(),
        ));
      }
    } catch (e) {
      if (isClosed) return;
      emit(FavoritesError(message: _extractMessage(e)));
      await loadFavorites();
    }
  }

  String _extractMessage(Object e) {
    if (e is ApiException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}