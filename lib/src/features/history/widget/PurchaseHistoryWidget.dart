import 'package:black_market/src/core/model/ProductsModel.dart';
import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/consts/AppColors.dart';

class ItemCard extends StatefulWidget {
  final ProductModel item;

  const ItemCard({super.key, required this.item});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double _scale = 1.0;
  bool _glow = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);
        final cardColor = AppColors.instance.getCardBackground(isDark);

        return Card(
          elevation: 2,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.network(
                    item.images.first,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.workSans(color: themeColor, fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.brand,
                        style: GoogleFonts.workSans(fontSize: 12, color: themeColorSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toStringAsFixed(1),
                            style: GoogleFonts.workSans(color: themeColor, fontSize: 12),
                          ),
                          const Spacer(),
                          Text(
                            item.price.toString(),
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: AppColors.instance.red,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: AppColors.instance.red.withOpacity(0.5),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      GestureDetector(
                        onTapDown: (_) =>
                            setState(() {
                              _scale = 0.95;
                              _glow = true;
                              HapticFeedback.lightImpact();
                            }),
                        onTapUp: (_) =>
                            setState(() {
                              _scale = 1.0;
                              _glow = false;
                            }),
                        onTapCancel: () =>
                            setState(() {
                              _scale = 1.0;
                              _glow = false;
                            }),
                        child: AnimatedScale(
                          scale: _scale,
                          duration: const Duration(milliseconds: 150),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              boxShadow: _glow
                                  ? [
                                BoxShadow(
                                  color: AppColors.instance.cyanAccent.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                )
                              ]
                                  : [],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  AppRouter.push(context, AppRoutes.sellPage, arguments: item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? AppColors.instance.white : AppColors.instance.black,
                                  foregroundColor: isDark ? AppColors.instance.black : AppColors.instance.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: themeColor, width: 2),
                                  ),
                                  elevation: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Buy Now',
                                        style: GoogleFonts.workSans(fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Icon(Icons.shopping_cart_checkout_outlined,
                                        size: 18, color: isDark ? AppColors.instance.black : AppColors.instance.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
