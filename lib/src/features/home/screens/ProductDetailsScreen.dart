import 'package:black_market/src/core/utils/consts/AppColors.dart';
import 'package:black_market/src/core/model/ProductsModel.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import '../../../core/utils/consts/AppRouter.dart';
import '../../favorites/cubit/FavoritesCubit.dart';
import '../../favorites/cubit/FavoritesState.dart';

class SellPage extends StatefulWidget {
  final ProductModel model;

  const SellPage({super.key, required this.model});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  bool _addedToCart = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: isDark ? Colors.white : Colors.grey.shade200,
                          child: Image.network(
                            model.images.first,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.45),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: themeColor.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        model.brand,
                        style: GoogleFonts.workSans(
                          color: themeColor.withOpacity(0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${model.price}",
                            style: GoogleFonts.workSans(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.instance.red,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: AppColors.instance.red.withOpacity(0.5),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 24),
                              const SizedBox(width: 5),
                              Text(
                                model.rating.toStringAsFixed(1),
                                style: GoogleFonts.workSans(
                                  color: themeColor, 
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      
                      // Shipping & Warranty Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.instance.shadeblack : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.verified_user_outlined, "Warranty", model.warrantyInformation ?? "No warranty", themeColor, isDark),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.local_shipping_outlined, "Shipping", model.shippingInformation ?? "No shipping info", themeColor, isDark),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      Text(
                        "Description",
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        model.description,
                        style: GoogleFonts.workSans(
                          color: themeColor.withOpacity(0.8),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildQuantityButton(Icons.remove, () {
                                if (quantity > 1) setState(() => quantity--);
                              }, themeColor),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  quantity.toString(),
                                  style: GoogleFonts.workSans(
                                    color: themeColor, 
                                    fontSize: 22, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildQuantityButton(Icons.add, () {
                                setState(() => quantity++);
                              }, themeColor),
                            ],
                          ),
                          BlocBuilder<FavoriteCubit, FavoriteState>(
                            builder: (context, state) {
                              final isFavorite = context.read<FavoriteCubit>().isFavorite(model);
                              return IconButton(
                                icon: Icon(
                                  isFavorite ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                                  color: isFavorite ? AppColors.instance.cyanAccent : themeColor,
                                  size: 30,
                                ),
                                onPressed: () => context.read<FavoriteCubit>().toggleFavorite(model),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          toastification.show(
                            title: Text('${model.title} x$quantity added to cart', style: GoogleFonts.workSans(fontSize: 16)),
                            type: ToastificationType.success,
                          );
                          setState(() => _addedToCart = true);
                          await Future.delayed(const Duration(seconds: 1));
                          if (mounted) setState(() => _addedToCart = false);
                          AppRouter.push(context, AppRoutes.bottomNav);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.instance.white : AppColors.instance.black,
                          minimumSize: const Size(double.infinity, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: themeColor, width: 2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _addedToCart ? "ADDED" : "ADD TO CART",
                              style: GoogleFonts.workSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _addedToCart
                                  ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                                  : Icon(Icons.shopping_cart_outlined, color: isDark ? Colors.black : Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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

  Widget _buildInfoRow(IconData icon, String label, String value, Color themeColor, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: AppColors.instance.cyanAccent, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.workSans(color: themeColor.withOpacity(0.5), fontSize: 12)),
            Text(value, style: GoogleFonts.workSans(color: themeColor, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap, Color themeColor) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: themeColor, size: 20),
      ),
    );
  }
}
