import 'dart:ui';
import 'package:black_market/src/core/consts/AppColors.dart';
import 'package:black_market/src/features/basket/cubit/BasketCubit.dart';
import 'package:black_market/src/features/basket/screens/BasketScreen.dart';
import 'package:black_market/src/features/favorites/screens/FavoritesScreen.dart';
import 'package:black_market/src/features/home/presentation/screens/HomeScreen.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:black_market/src/features/settings/screens/SettingsScreen.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  static const _icons = [
    CupertinoIcons.home,
    CupertinoIcons.cart,
    CupertinoIcons.bookmark,
    CupertinoIcons.settings,
  ];

  final List<Widget> _pages = const [
    HomeScreen(),
    BasketScreen(),
    FavoritePage(),
    SettingsScreen(),
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

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final barHeight = r.isSmallMobile ? 64.0 : (r.isTablet ? 76.0 : 70.0);
    final iconSize = r.isSmallMobile ? 24.0 : (r.isTablet ? 28.0 : 26.0);
    final horizontalInset = r.pagePadding.left;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final accent = AppColors.instance.cyanAccent;

        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(
              horizontalInset,
              0,
              horizontalInset,
              r.isSmallMobile ? 8 : 12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.03),
                            ]
                          : [
                              Colors.white.withOpacity(0.92),
                              // Higher opacity for Light Mode
                              Colors.white.withOpacity(0.75),
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.black.withOpacity(0.15),
                      // Darker border in light mode
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.35 : 0.18),
                        // Stronger shadow for better definition
                        blurRadius: 32,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth / _icons.length;
                      final bubbleSize = r.isSmallMobile ? 44.0 : 50.0;
                      final left =
                          (_selectedIndex * itemWidth) +
                          (itemWidth - bubbleSize) / 2;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Floating Glowing Indicator (Premium Cyan Glow)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutQuart,
                            left: left,
                            top: (barHeight - bubbleSize) / 2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeOutQuart,
                              width: bubbleSize,
                              height: bubbleSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    accent.withOpacity(0.4),
                                    accent.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(_icons.length, (index) {
                              return Expanded(
                                child: _GlassNavItem(
                                  icon: _icons[index],
                                  selected: _selectedIndex == index,
                                  themeColor: themeColor,
                                  accent: accent,
                                  iconSize: iconSize,
                                  badgeCount: index == 1
                                      ? context
                                            .watch<BasketCubit>()
                                            .state
                                            .totalItems
                                      : 0,
                                  onTap: () => _onTap(index),
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color themeColor;
  final Color accent;
  final double iconSize;
  final int badgeCount;
  final VoidCallback onTap;

  const _GlassNavItem({
    required this.icon,
    required this.selected,
    required this.themeColor,
    required this.accent,
    required this.iconSize,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: accent.withOpacity(0.08),
            highlightColor: Colors.transparent,
            child: SizedBox.expand(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutBack,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          icon,
                          key: ValueKey('$icon-$selected'),
                          size: iconSize,
                          color: selected
                              ? accent
                              : (isDark
                                    ? themeColor.withOpacity(0.7)
                                    : Colors.black54),
                        ),
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -10,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.instance.red,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(minWidth: 16),
                          child: Text(
                            badgeCount > 99 ? '99+' : '$badgeCount',
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
              ),
            ),
          ),
        );
      },
    );
  }
}
