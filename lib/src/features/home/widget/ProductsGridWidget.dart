import 'package:black_market/src/core/widget/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/consts/AppRouter.dart';
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
        if (state.status == HomeStatus.loading) {
          return buildGridShimmerSliver(isDark);
        }

        if (state.status == HomeStatus.error) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                state.errorText ?? "Error",
                style: GoogleFonts.workSans(color: themeColor),
              ),
            ),
          );
        }

        final products = state.filteredProducts;

        if (products.isEmpty && state.status == HomeStatus.success) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                "No products found",
                style: GoogleFonts.workSans(
                  color: themeColor,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == products.length) {
                return const ShimmerWidget();
              }
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
                  AppRouter.push(context, AppRoutes.sellPage, arguments: product);
                },
              );
            },
            childCount: products.length + (state.isLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}

Widget buildGridShimmerSliver(bool isDark) {
  return SliverGrid(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.78,
    ),
    delegate: SliverChildBuilderDelegate(
      (context, index) => CardShimmer(isDark: isDark),
      childCount: 6,
    ),
  );
}
