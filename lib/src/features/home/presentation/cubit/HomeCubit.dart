import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:black_market/src/core/utils/exception/exception_mapper.dart';
import 'package:black_market/src/features/home/data/model/ProductsModel.dart';
import 'package:black_market/src/features/home/domain/usecase/get_products_usecase.dart';
import 'package:black_market/src/features/home/presentation/cubit/HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({required this.getProductsUseCase}) : super(const HomeState());

  int skip = 0;
  bool hasMore = true;

  Future<void> loadMore() async {
    if (state.isLoading || !hasMore) return;

    if (state.products.isEmpty) {
      emit(state.copyWith(isLoading: true, status: HomeStatus.loading));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    final int fetchLimit = state.products.isEmpty ? 100 : 30;
    final result = await getProductsUseCase(
      GetProductsParams(skip: skip, limit: fetchLimit),
    );

    result.either(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            status: HomeStatus.error,
            errorText: failure.message,
          ),
        );
      },
      (entities) {
        final List<ProductModel> products =
            entities.map(ProductModel.fromEntity).toList();
        skip += products.length;

        if (products.isEmpty) {
          hasMore = false;
        }

        final List<ProductModel> allProducts = [
          ...state.products,
          ...products,
        ];

        List<ProductModel> featured = List<ProductModel>.from(
          state.featuredProducts,
        );
        if (featured.isEmpty && allProducts.isNotEmpty) {
          final random = Random();
          final Set<int> indices = {};
          while (indices.length < 3 && indices.length < allProducts.length) {
            indices.add(random.nextInt(allProducts.length));
          }
          featured = indices.map((i) => allProducts[i]).toList();
        }

        emit(
          state.copyWith(
            isLoading: false,
            status: HomeStatus.success,
            products: allProducts,
            filteredProducts: _applyFilters(
              allProducts,
              state.searchQuery,
              state.selectedCategory,
            ),
            featuredProducts: featured,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Pull-to-refresh: resets pagination and reloads products.
  Future<void> refresh() async {
    skip = 0;
    hasMore = true;
    emit(
      state.copyWith(
        isLoading: true,
        status: HomeStatus.loading,
        products: const [],
        filteredProducts: const [],
        featuredProducts: const [],
        clearError: true,
      ),
    );

    final result = await getProductsUseCase(
      const GetProductsParams(skip: 0, limit: 100),
    );

    result.either(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            status: HomeStatus.error,
            errorText: failure.message,
          ),
        );
      },
      (entities) {
        final List<ProductModel> products =
            entities.map(ProductModel.fromEntity).toList();
        skip = products.length;
        hasMore = products.isNotEmpty;

        List<ProductModel> featured = <ProductModel>[];
        if (products.isNotEmpty) {
          final random = Random();
          final Set<int> indices = {};
          while (indices.length < 3 && indices.length < products.length) {
            indices.add(random.nextInt(products.length));
          }
          featured = indices.map((i) => products[i]).toList();
        }

        emit(
          state.copyWith(
            isLoading: false,
            status: HomeStatus.success,
            products: products,
            filteredProducts: _applyFilters(
              products,
              state.searchQuery,
              state.selectedCategory,
            ),
            featuredProducts: featured,
            clearError: true,
          ),
        );
      },
    );
  }

  void search(String query) {
    final searchQuery = query.toLowerCase();
    emit(
      state.copyWith(
        searchQuery: searchQuery,
        filteredProducts: _applyFilters(
          state.products,
          searchQuery,
          state.selectedCategory,
        ),
      ),
    );
  }

  void selectCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: _applyFilters(
          state.products,
          state.searchQuery,
          category,
        ),
      ),
    );
  }

  List<ProductModel> _applyFilters(
    List<ProductModel> products,
    String? query,
    String category,
  ) {
    var result = products;

    if (category != "All") {
      result = result.where((p) {
        final productCategory = p.category.toLowerCase();
        final selectedCat = category.toLowerCase();

        if (selectedCat == "beauty") {
          return productCategory == "beauty" ||
              productCategory == "fragrances" ||
              productCategory == "skin-care";
        }

        if (selectedCat == "daily") {
          return productCategory == "groceries" ||
              productCategory == "kitchen-accessories";
        }

        if (selectedCat == "tech") {
          return productCategory == "smartphones" ||
              productCategory == "laptops" ||
              productCategory == "tablets" ||
              productCategory == "mobile-accessories";
        }

        if (selectedCat == "fashion") {
          if (productCategory.contains("laptop") ||
              productCategory.contains("phone") ||
              productCategory.contains("tablet") ||
              productCategory.contains("accessories")) {
            return false;
          }

          return productCategory.contains("shirt") ||
              productCategory.contains("shoes") ||
              productCategory.contains("bag") ||
              productCategory.contains("dress") ||
              productCategory.contains("tops") ||
              productCategory.contains("sunglasses") ||
              productCategory.contains("jewellery");
        }

        if (selectedCat == "furniture") {
          return productCategory == "furniture" ||
              productCategory == "home-decoration";
        }

        if (selectedCat == "watches") {
          return productCategory.contains("watch");
        }

        return productCategory == selectedCat;
      }).toList();
    }

    if (query != null && query.isNotEmpty) {
      result = result.where((product) {
        final title = product.title.toLowerCase();
        final brand = product.brand.toLowerCase();
        return title.contains(query) || brand.contains(query);
      }).toList();
    }

    return result;
  }

  void showSearchSuggestions() {
    emit(state.copyWith(showSuggestions: true));
  }

  void hideSearchSuggestions() {
    emit(state.copyWith(showSuggestions: false));
  }

  /// Fallback when unexpected errors bubble up outside Either.
  String friendlyError(Object error) => ExceptionMapper.toUserMessage(error);
}
