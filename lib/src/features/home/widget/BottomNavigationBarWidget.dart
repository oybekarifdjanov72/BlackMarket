import 'package:black_market/src/features/basket/screens/BasketScreen.dart';
import 'package:black_market/src/features/basket/cubit/BasketCubit.dart';
import 'package:black_market/src/features/basket/cubit/BasketState.dart';
import 'package:black_market/src/features/favorites/screens/FavoritesScreen.dart';
import 'package:black_market/src/features/settings/screens/SettingsScreen.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../screens/HomeScreen.dart';


class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const BasketScreen(),
    const FavoritePage(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    context.read<SettingsCubit>().updateSystemTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            height: 65,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(top: BorderSide(color: themeColor.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(CupertinoIcons.home, 0, themeColor),
                BlocBuilder<BasketCubit, BasketState>(
                  builder: (context, basketState) {
                    return _buildNavItem(
                      CupertinoIcons.cart,
                      1,
                      themeColor,
                      badgeCount: basketState.totalItems,
                    );
                  },
                ),
                _buildNavItem(CupertinoIcons.bookmark, 2, themeColor),
                _buildNavItem(CupertinoIcons.settings, 3, themeColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color themeColor, {int badgeCount = 0}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 30,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
                color: isSelected ? AppColors.instance.cyanAccent : themeColor,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.instance.cyanAccent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
