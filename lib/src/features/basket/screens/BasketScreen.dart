import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:black_market/src/core/widget/SmoothEntryAnimation.dart';
import '../../../core/consts/AppColors.dart';
import '../../../core/consts/AppRouter.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';
import '../cubit/BasketCubit.dart';
import '../cubit/BasketState.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

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
            title: SmoothEntryAnimation(
              navIndex: 1,
              slideOffset: const Offset(0, -20),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your ',
                      style: GoogleFonts.workSans(
                        fontSize: r.titleSize(26),
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
                    TextSpan(
                      text: 'Basket',
                      style: GoogleFonts.workSans(
                        fontSize: r.titleSize(26),
                        fontWeight: FontWeight.bold,
                        color: AppColors.instance.cyanAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: AppColors.instance.cyanAccent.withOpacity(0.8),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: ResponsivePage(
            child: BlocBuilder<BasketCubit, BasketState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return _EmptyBasket(themeColor: themeColor);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(0), // Handled by ResponsivePage
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return SmoothEntryAnimation(
                      navIndex: 1,
                      delay: Duration(milliseconds: index * 100),
                      child: _BasketItemCard(item: item, isDark: isDark, themeColor: themeColor),
                    );
                  },
                );
              },
            ),
          ),
          bottomNavigationBar: SmoothEntryAnimation(
            navIndex: 1,
            slideOffset: const Offset(0, 40),
            child: _BasketBottomBar(isDark: isDark, themeColor: themeColor, bgColor: bgColor),
          ),
        );
      },
    );
  }
}

class _BasketItemCard extends StatelessWidget {
  final BasketItem item;
  final bool isDark;
  final Color themeColor;

  const _BasketItemCard({required this.item, required this.isDark, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final cardColor = AppColors.instance.getCardBackground(isDark);

    return Dismissible(
      key: Key(item.product.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<BasketCubit>().removeFromBasket(item.product.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.instance.red,
          borderRadius: BorderRadius.circular(r.isSmallMobile ? 12 : 15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.isSmallMobile ? 14 : 18)),
        child: Padding(
          padding: EdgeInsets.all(r.isSmallMobile ? 10 : 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.product.thumbnail,
                  width: r.value(mobile: 80, smallMobile: 65),
                  height: r.value(mobile: 80, smallMobile: 65),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: r.isSmallMobile ? 10 : 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.workSans(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: r.bodySize(16),
                      ),
                    ),
                    SizedBox(height: r.isSmallMobile ? 2 : 5),
                    Text(
                      "\$${item.product.price}",
                      style: GoogleFonts.workSans(
                        color: AppColors.instance.red,
                        fontWeight: FontWeight.bold,
                        fontSize: r.bodySize(18),
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.redAccent.withOpacity(0.5),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: () => context.read<BasketCubit>().updateQuantity(item.product.id, -1), themeColor: themeColor),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.isSmallMobile ? 8 : 12),
                    child: Text(
                      item.quantity.toString(),
                      style: GoogleFonts.workSans(color: themeColor, fontSize: r.bodySize(18), fontWeight: FontWeight.bold),
                    ),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: () => context.read<BasketCubit>().updateQuantity(item.product.id, 1), themeColor: themeColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color themeColor;

  const _QtyBtn({required this.icon, required this.onTap, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.isSmallMobile ? 3 : 4),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: themeColor, size: r.isSmallMobile ? 16 : 20),
      ),
    );
  }
}

class _BasketBottomBar extends StatelessWidget {
  final bool isDark;
  final Color themeColor;
  final Color bgColor;

  const _BasketBottomBar({required this.isDark, required this.themeColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<BasketCubit, BasketState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.fromLTRB(
            r.isSmallMobile ? 18 : 24,
            r.isSmallMobile ? 18 : 24,
            r.isSmallMobile ? 18 : 24,
            (r.isSmallMobile ? 18 : 24) + (r.isSmallMobile ? 65 : 70), // Lifted even higher to ensure no overlap
          ),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: themeColor.withOpacity(0.1))),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.maxContentWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: GoogleFonts.workSans(color: themeColor, fontSize: r.bodySize(24), fontWeight: FontWeight.bold),
                    ),
                    SmoothEntryAnimation(
                      delay: const Duration(milliseconds: 200),
                      slideOffset: const Offset(20, 0),
                      child: Text(
                        "\$${state.totalPrice.toStringAsFixed(2)}",
                        style: GoogleFonts.workSans(
                          color: themeColor, 
                          fontSize: r.bodySize(24), 
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: themeColor.withOpacity(0.5), blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.isSmallMobile ? 14 : 16),
                SmoothEntryAnimation(
                  delay: const Duration(milliseconds: 400),
                  slideOffset: const Offset(0, 20),
                  child: ElevatedButton(
                    onPressed: () {
                      AppRouter.push(context, AppRoutes.checkOut);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      minimumSize: Size(double.infinity, r.isSmallMobile ? 52 : 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "CHECKOUT",
                      style: GoogleFonts.workSans(
                        color: isDark ? Colors.black : Colors.white,
                        fontSize: r.bodySize(18),
                        fontWeight: FontWeight.bold,
                      ),
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

class _EmptyBasket extends StatelessWidget {
  final Color themeColor;
  const _EmptyBasket({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: r.value(mobile: 100, smallMobile: 80), color: themeColor.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "Your basket is empty",
            style: GoogleFonts.workSans(color: themeColor, fontSize: r.titleSize(22), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => AppRouter.pushAndRemoveUntil(context, AppRoutes.bottomNav, (_) => false),
            child: Text(
              "Continue Shopping",
              style: GoogleFonts.workSans(color: AppColors.instance.cyanAccent, fontSize: r.bodySize(18), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
