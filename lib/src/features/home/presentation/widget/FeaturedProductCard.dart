import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/model/ProductsModel.dart';
import 'package:black_market/src/core/consts/AppColors.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';

class FeaturedProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final cardColor = AppColors.instance.getCardBackground(isDark);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), // Increased horizontal margin to reduce width
            padding: EdgeInsets.all(r.isSmallMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(r.featuredCardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left side: Image
                Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.instance.shadeblack : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(r.isSmallMobile ? 10 : 15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(r.isSmallMobile ? 10 : 15),
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          color: themeColor,
                          size: r.value(mobile: 30, smallMobile: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.isSmallMobile ? 12 : 15),
                // Right side: Info
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: r.bodySize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.brand,
                        style: GoogleFonts.workSans(
                          color: Colors.grey[500],
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
                        style: GoogleFonts.workSans(
                          color: AppColors.instance.greenAccent,
                          fontSize: r.bodySize(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!r.isSmallMobile)
                        Text(
                          product.shippingInformation ?? "Standard shipping",
                          style: GoogleFonts.workSans(
                            color: Colors.grey[500],
                            fontSize: r.bodySize(11),
                          ),
                        ),
                      SizedBox(height: r.isSmallMobile ? 4 : 6),
                      Text(
                        "\$${product.price}",
                        style: GoogleFonts.workSans(
                          color: AppColors.instance.red,
                          fontSize: r.titleSize(18),
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: AppColors.instance.red.withOpacity(0.8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
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
