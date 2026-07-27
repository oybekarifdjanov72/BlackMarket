import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import '../../../core/model/ProductsModel.dart';
import '../../../core/service/ApiService.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  int skip = 0;
  bool hasMore = true;

  Future<void> loadMore() async {
    if (state.isLoading || !hasMore) return;

    if (state.products.isEmpty) {
      emit(state.copyWith(isLoading: true, status: HomeStatus.loading));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final int fetchLimit = state.products.isEmpty ? 100 : 30;
      final products = await ApiService.getProducts(skip: skip, limit: fetchLimit);

      skip += products.length;

      if (products.isEmpty) {
        hasMore = false;
      }

      final allProducts = [...state.products, ...products];
      
      List<ProductModel> featured = List.from(state.featuredProducts);
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
          filteredProducts: _applyFilters(allProducts, state.searchQuery, state.selectedCategory),
          featuredProducts: featured,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: HomeStatus.error,
          errorText: e.toString(),
        ),
      );
    }
  }

  void search(String query) {
    final searchQuery = query.toLowerCase();
    emit(
      state.copyWith(
        searchQuery: searchQuery,
        filteredProducts: _applyFilters(state.products, searchQuery, state.selectedCategory),
      ),
    );
  }

  void selectCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: _applyFilters(state.products, state.searchQuery, category),
      ),
    );
  }

  List<ProductModel> _applyFilters(List<ProductModel> products, String? query, String category) {
    var result = products;
    
    if (category != "All") {
      result = result.where((p) {
        final productCategory = p.category.toLowerCase();
        final selectedCat = category.toLowerCase();
        
        switch (selectedCat) {
          case "beauty":
            return productCategory == "beauty" || productCategory == "fragrances" || productCategory == "skin-care";
          case "daily":
            return productCategory == "groceries" || productCategory == "kitchen-accessories";
          case "tech":
            return productCategory == "smartphones" || 
                   productCategory == "laptops" || 
                   productCategory == "tablets" || 
                   productCategory == "mobile-accessories";
          case "fashion":
            if (productCategory.contains("laptop") || productCategory.contains("phone")) return false;
            
            return productCategory.contains("shirt") || 
                   productCategory.contains("shoes") || 
                   productCategory.contains("bag") || 
                   productCategory.contains("dress") || 
                   productCategory.contains("tops") || 
                   productCategory.contains("sunglasses") ||
                   productCategory.contains("jewellery");
          case "furniture":
            return productCategory == "furniture" || productCategory == "home-decoration";
          case "watches":
            return productCategory.contains("watch");
          default:
            return productCategory == selectedCat;
        }
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
}
