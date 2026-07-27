import 'package:flutter/cupertino.dart';

import '../../../core/model/ProductsModel.dart';

class HomeState {
  final String? errorText;
  final bool isLoading;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final String? searchQuery;
  final String selectedCategory;
  final HomeStatus status;
  final bool showSuggestions;
  final List<ProductModel> featuredProducts;

  HomeState({
    this.showSuggestions = false,
    this.status = HomeStatus.initial,
    this.errorText,
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery,
    this.selectedCategory = "All",
    this.isLoading = false,
    this.featuredProducts = const [],
  });

  HomeState copyWith({
    bool? showSuggestions,
    String? errorText,
    bool? isLoading,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    HomeStatus? status,
    List<ProductModel>? featuredProducts,
  }) {
    return HomeState(
      showSuggestions: showSuggestions ?? this.showSuggestions,
      errorText: errorText ?? this.errorText,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      status: status ?? this.status,
      featuredProducts: featuredProducts ?? this.featuredProducts,
    );
  }
}

enum HomeStatus { initial, loading, error, success }

ValueNotifier<bool> noMoreData = ValueNotifier(false);