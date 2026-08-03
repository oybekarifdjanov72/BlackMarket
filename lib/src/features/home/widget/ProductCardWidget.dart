import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../core/model/ProductsModel.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../basket/cubit/BasketCubit.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';

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
              borderRadius: BorderRadius.circular(18),
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
                          errorBuilder: (_, __, ___) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: themeColorSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
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
                              fontSize: 12,
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
                    padding: const EdgeInsets.all(10),
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
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: themeColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: GoogleFonts.workSans(
                                color: themeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.warrantyInformation ?? "No warranty",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.workSans(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "\$${product.price}",
                                style: GoogleFonts.workSans(
                                  color: AppColors.instance.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                            InkWell(
                              onTap: () {
                                context.read<BasketCubit>().addToBasket(
                                  product,
                                );
                                toastification.show(
                                  title: Text(
                                    "${product.title} added to basket",
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  type: ToastificationType.info,
                                  autoCloseDuration: Duration(seconds: 3),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(6),
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
                                  size: 22,
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
