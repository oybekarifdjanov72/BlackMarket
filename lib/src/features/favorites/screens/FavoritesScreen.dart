import 'package:black_market/src/core/utils/consts/AppRouter.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import '../../../core/model/ProductsModel.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../../core/widget/CustomAppButton.dart';
import '../cubit/FavoritesCubit.dart';
import '../cubit/FavoritesState.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                fontSize: 24,
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
            actions: [
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state.favorites.isEmpty) {
                    return const SizedBox();
                  }

                  return IconButton(
                    onPressed: () {
                      context.read<FavoriteCubit>().clearFavorites();
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              if (state.favorites.isEmpty) {
                return _EmptyFavorite(themeColor: themeColor);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return _FavoriteCard(product: product, themeColor: themeColor);
                },
              );
            },
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
    final isDark = context.read<SettingsCubit>().state.isDarkMode;
    final cardColor = AppColors.instance.getCardBackground(isDark);
    final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<FavoriteCubit>().toggleFavorite(product);
        toastification.show(type: ToastificationType.info, title: Text("${product.title} was removed", style: GoogleFonts.workSans(fontSize: 18, fontWeight: FontWeight.bold),));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: AppColors.instance.white),
      ),
      child: Card(
        color: cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            AppRouter.push(context, AppRoutes.sellPage, arguments: product);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.thumbnail,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: themeColor,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          product.brand,
                          style: GoogleFonts.workSans(
                            color: themeColorSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber,
                                size: 18),
                            const SizedBox(width: 5),
                            Text(
                              product.rating.toString(),
                              style: GoogleFonts.workSans(
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "\$${product.price}",
                          style: GoogleFonts.workSans(
                            color: Colors.red,
                            fontSize: 20,
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
    final isDark = context.read<SettingsCubit>().state.isDarkMode;
    final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 90,
            color: themeColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            "No Favorites Yet",
            style: GoogleFonts.workSans(
              color: themeColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Save products you like",
            style: GoogleFonts.workSans(
              color: themeColorSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
