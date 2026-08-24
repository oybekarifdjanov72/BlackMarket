import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'package:black_market/src/core/model/ProductsModel.dart';
import 'package:black_market/src/core/consts/AppColors.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:black_market/src/features/basket/cubit/BasketCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);
        final cardColor = AppColors.instance.getCardBackground(isDark);

        return GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 5,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.gridCardRadius),
              side: BorderSide(color: themeColor.withOpacity(0.1)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: isDark
                            ? AppColors.instance.shadeblack
                            : Colors.grey.shade100,
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: themeColorSecondary,
                                size: r.value(mobile: 24, smallMobile: 18),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: r.isSmallMobile ? 4 : 8,
                        right: r.isSmallMobile ? 4 : 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.isSmallMobile ? 4 : 6,
                            vertical: r.isSmallMobile ? 2 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.instance.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "-${product.discountPercentage.toStringAsFixed(0)}%",
                            style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: r.isSmallMobile ? 10 : 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.isSmallMobile ? 8 : 10,
                      vertical: r.isSmallMobile ? 7 : 9,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: r.bodySize(15),
                          ),
                        ),
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: themeColorSecondary,
                            fontSize: r.bodySize(12),
                          ),
                        ),
                        SizedBox(height: r.isSmallMobile ? 2 : 4),
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
                        SizedBox(height: r.isSmallMobile ? 2 : 4),
                        Text(
                          product.warrantyInformation ?? "No warranty",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: Colors.greenAccent,
                            fontSize: r.bodySize(12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10), // Minimum 10px space
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\$${product.price}",
                                  style: GoogleFonts.workSans(
                                    color: AppColors.instance.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: r.bodySize(18),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: AppColors.instance.red.withOpacity(
                                          0.8,
                                        ),
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.read<BasketCubit>().addToBasket(product);
                                toastification.show(
                                  title: Text(
                                    "${product.title} added to basket",
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: r.bodySize(15),
                                    ),
                                  ),
                                  type: ToastificationType.info,
                                  autoCloseDuration: const Duration(seconds: 3),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(r.isSmallMobile ? 4 : 6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.instance.white
                                      : AppColors.instance.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  CupertinoIcons.cart_badge_plus,
                                  color: isDark
                                      ? AppColors.instance.black
                                      : AppColors.instance.white,
                                  size: r.isSmallMobile ? 18 : 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
