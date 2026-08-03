import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/consts/AppRouter.dart';
import '../../../core/widget/ShimmerWidget.dart';
import '../cubit/HomeCubit.dart';
import '../cubit/HomeState.dart';
import 'ProductCardWidget.dart';

class ProductGrid extends StatelessWidget {
  final bool isDark;
  final Color themeColor;

  const ProductGrid({
    super.key,
    required this.isDark,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final products = state.filteredProducts;

        // Use Shimmer while loading initial data
        if (state.status == HomeStatus.loading && state.products.isEmpty) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => CardShimmer(isDark: isDark),
              childCount: 6,
            ),
          );
        }

        if (state.status == HomeStatus.error && products.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                state.errorText ?? "An error occurred",
                textAlign: TextAlign.center,
                style: TextStyle(color: themeColor, fontSize: 16),
              ),
            ),
          );
        }

        if (products.isEmpty && !state.isLoading) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                "No products found",
                style: TextStyle(color: themeColor, fontSize: 18),
              ),
            ),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.58,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  AppRouter.push(
                    context,
                    AppRoutes.sellPage,
                    arguments: product,
                  );
                },
                onAddToCart: () {
                  // Handled inside ProductCard
                },
              );
            },
            childCount: products.length,
          ),
        );
      },
    );
  }
}
