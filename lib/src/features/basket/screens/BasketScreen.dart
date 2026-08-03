import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../../core/utils/consts/AppRouter.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';
import '../cubit/BasketCubit.dart';
import '../cubit/BasketState.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

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
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Your ',
                    style: GoogleFonts.workSans(
                      fontSize: 26,
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
                      fontSize: 26,
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
          body: BlocBuilder<BasketCubit, BasketState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                return _EmptyBasket(themeColor: themeColor);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return _BasketItemCard(item: item, isDark: isDark, themeColor: themeColor);
                },
              );
            },
          ),
          bottomNavigationBar: _BasketBottomBar(isDark: isDark, themeColor: themeColor, bgColor: bgColor),
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
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.product.thumbnail,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
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
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\$${item.product.price}",
                      style: GoogleFonts.workSans(
                        color: AppColors.instance.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item.quantity.toString(),
                      style: GoogleFonts.workSans(color: themeColor, fontSize: 18, fontWeight: FontWeight.bold),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: themeColor, size: 20),
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
    return BlocBuilder<BasketCubit, BasketState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: themeColor.withOpacity(0.1))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: GoogleFonts.workSans(color: themeColor, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "\$${state.totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.workSans(
                      color: themeColor, 
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: themeColor.withOpacity(0.5), blurRadius: 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AppRouter.push(context, AppRoutes.checkOut);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  "CHECKOUT",
                  style: GoogleFonts.workSans(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

class _EmptyBasket extends StatelessWidget {
  final Color themeColor;
  const _EmptyBasket({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 100, color: themeColor.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "Your basket is empty",
            style: GoogleFonts.workSans(color: themeColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => AppRouter.pushAndRemoveUntil(context, AppRoutes.bottomNav, (_) => false),
            child: Text(
              "Continue Shopping",
              style: GoogleFonts.workSans(color: AppColors.instance.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
