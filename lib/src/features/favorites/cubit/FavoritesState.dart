import '../../../core/model/ProductsModel.dart';

class FavoriteState {
  final List<ProductModel> favorites;

  const FavoriteState({
    this.favorites = const [],
  });

  FavoriteState copyWith({
    List<ProductModel>? favorites,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
    );
  }
}