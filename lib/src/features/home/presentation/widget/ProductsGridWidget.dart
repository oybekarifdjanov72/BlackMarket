import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:black_market/src/core/widget/ShimmerWidget.dart';
import 'package:black_market/src/features/home/presentation/cubit/HomeCubit.dart';
import 'package:black_market/src/features/home/presentation/cubit/HomeState.dart';
import 'package:black_market/src/features/home/presentation/widget/ProductCardWidget.dart';

import '../../../basket/cubit/BasketCubit.dart';

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
    final r = AppResponsive.of(context);
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: r.productGridColumns,
      childAspectRatio: r.productGridAspectRatio,
      crossAxisSpacing: r.isSmallMobile ? 12 : 16,
      mainAxisSpacing: r.isSmallMobile ? 12 : 16,
    );

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final products = state.filteredProducts;

        if (state.status == HomeStatus.loading && state.products.isEmpty) {
          return SoftSliverPadding(
            child: SliverGrid(
              gridDelegate: gridDelegate,
              delegate: SliverChildBuilderDelegate(
                (context, index) => CardShimmer(isDark: isDark),
                childCount: r.productGridColumns * 3,
              ),
            ),
          );
        }

        if (state.status == HomeStatus.error && products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: r.value(mobile: 48, smallMobile: 40, tablet: 56),
                      color: themeColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorText ??
                          'Something went wrong, please try again!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.workSans(
                        color: themeColor,
                        fontSize: r.bodySize(16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.read<HomeCubit>().refresh(),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Try again',
                        style: GoogleFonts.workSans(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Or pull down to refresh',
                      style: GoogleFonts.workSans(
                        color: themeColor.withOpacity(0.6),
                        fontSize: r.bodySize(13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (products.isEmpty && !state.isLoading) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                "No products found",
                style: GoogleFonts.workSans(
                  color: themeColor,
                  fontSize: r.bodySize(18),
                ),
              ),
            ),
          );
        }

        return SoftSliverPadding(
          bottom: r.bottomNavClearance,
          child: SliverGrid(
            gridDelegate: gridDelegate,
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
                    context.read<BasketCubit>().addToBasket(product);
                  },
                );
              },
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }
}

/// Horizontal + optional bottom padding for slivers, centered on tablet.
class SoftSliverPadding extends StatelessWidget {
  final Widget child;
  final double? bottom;

  const SoftSliverPadding({
    super.key,
    required this.child,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final h = r.isSmallMobile ? 8.0 : 12.0; // Reduced from 16 to fit better
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(h, 0, h, bottom ?? 0),
      sliver: child,
    );
  }
}
