import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/model/ProductsModel.dart';
import 'FavoritesState.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString("favorites");

    if (json == null) return;

    final List decoded = jsonDecode(json);

    emit(
      state.copyWith(
        favorites: decoded
            .map((e) => ProductModel.fromJson(e))
            .toList(),
      ),
    );
  }



    Future<void> clearFavorites() async {
      emit(
        state.copyWith(
          favorites: [],
        ),
      );

      final prefs =
      await SharedPreferences.getInstance();

      prefs.remove("favorites");
    }
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data = state.favorites
        .map((e) => e.toJson())
        .toList();

    await prefs.setString(
      "favorites",
      jsonEncode(data),
    );
  }

  bool isFavorite(ProductModel product) {
    return state.favorites.any(
          (e) => e.id == product.id,
    );
  }
  Future<void> toggleFavorite(ProductModel product) async {
    List<ProductModel> list =
    List.from(state.favorites);

    if (isFavorite(product)) {
      list.removeWhere(
            (e) => e.id == product.id,
      );
    } else {
      list.add(product);
    }

    emit(
      state.copyWith(
        favorites: list,
      ),
    );

    await saveFavorites();
  }

}