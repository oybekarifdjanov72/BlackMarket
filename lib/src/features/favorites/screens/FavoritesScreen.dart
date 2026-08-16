import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/model/ProductsModel.dart';
import '../../../core/consts/AppColors.dart';
import '../cubit/FavoritesCubit.dart';
import '../cubit/FavoritesState.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: bgColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Favorites",
              style: GoogleFonts.workSans(
                fontSize: r.titleSize(24),
                fontWeight: FontWeight.bold,
                color: themeColor,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: themeColor.withOpacity(0.8),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          body: ResponsivePage(
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                if (state.favorites.isEmpty) {
                  return _EmptyFavorite(themeColor: themeColor);
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final product = state.favorites[index];
                    return _FavoriteCard(product: product, themeColor: themeColor);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final ProductModel product;
  final Color themeColor;

  const _FavoriteCard({required this.product, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isDark = context.read<SettingsCubit>().state.isDarkMode;
    final cardColor = AppColors.instance.getCardBackground(isDark);
    final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<FavoriteCubit>().toggleFavorite(product);
        toastification.show(type: ToastificationType.info, title: Text("${product.title} was removed", style: GoogleFonts.workSans(fontSize: r.bodySize(18), fontWeight: FontWeight.bold),));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: AppColors.instance.white),
      ),
      child: Card(
        color: cardColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.isSmallMobile ? 14 : 18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(r.isSmallMobile ? 14 : 18),
          onTap: () {
            AppRouter.push(context, AppRoutes.sellPage, arguments: product);
          },
          child: Padding(
            padding: EdgeInsets.all(r.isSmallMobile ? 10 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.thumbnail,
                      width: r.value(mobile: 100, smallMobile: 80, tablet: 120),
                      height: r.value(mobile: 100, smallMobile: 80, tablet: 120),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: r.isSmallMobile ? 10 : 15),
                Expanded(
                  child: SizedBox(
                    height: r.value(
                      mobile: 120,
                      smallMobile: 100,
                      tablet: 140,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE + DELETE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.workSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: r.bodySize(18),
                                  color: themeColor,
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            // DELETE BUTTON
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  context
                                      .read<FavoriteCubit>()
                                      .toggleFavorite(product);

                                  toastification.show(
                                    type: ToastificationType.info,
                                    title: Text(
                                      "${product.title} was removed",
                                      style: GoogleFonts.workSans(
                                        fontSize: r.bodySize(16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.15),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // BRAND
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: themeColorSecondary,
                            fontSize: r.bodySize(14),
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 17,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toString(),
                                style: GoogleFonts.workSans(
                                  color: themeColor,
                                  fontSize: r.bodySize(14),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "\$${product.price}",
                          style: GoogleFonts.workSans(
                            color: Colors.red,
                            fontSize: r.bodySize(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorite extends StatelessWidget {
  final Color themeColor;
  const _EmptyFavorite({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isDark = context.read<SettingsCubit>().state.isDarkMode;
    final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: r.value(mobile: 90, smallMobile: 70),
            color: themeColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            "No Favorites Yet",
            style: GoogleFonts.workSans(
              color: themeColor,
              fontSize: r.titleSize(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Save products you like",
            style: GoogleFonts.workSans(
              color: themeColorSecondary,
              fontSize: r.bodySize(16),
            ),
          ),
        ],
      ),
    );
  }
}
