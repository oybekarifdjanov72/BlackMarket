import 'package:equatable/equatable.dart';
import 'package:black_market/src/features/home/data/model/ProductsModel.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final List<ProductModel> featuredProducts;
  final String? errorText;
  final bool isLoading;
  final String? searchQuery;
  final String selectedCategory;
  final bool showSuggestions;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.filteredProducts = const [],
    this.featuredProducts = const [],
    this.errorText,
    this.isLoading = false,
    this.searchQuery = "",
    this.selectedCategory = "All",
    this.showSuggestions = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    List<ProductModel>? featuredProducts,
    String? errorText,
    bool clearError = false,
    bool? isLoading,
    String? searchQuery,
    String? selectedCategory,
    bool? showSuggestions,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      errorText: clearError ? null : (errorText ?? this.errorText),
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filteredProducts,
        featuredProducts,
        errorText,
        isLoading,
        searchQuery,
        selectedCategory,
        showSuggestions,
      ];
}
