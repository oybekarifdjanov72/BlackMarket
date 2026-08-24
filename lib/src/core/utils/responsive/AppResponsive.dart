import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// App breakpoints (mobile / tablet only — no desktop layouts).
abstract class AppBreakpoints {
  static const String smallMobile = 'SMALL_MOBILE';
  static const String mobile = MOBILE;
  static const String tablet = TABLET;
}

/// Convenience helpers for adapting UI to phone / tablet sizes.
class AppResponsive {
  final BuildContext context;

  const AppResponsive._(this.context);

  factory AppResponsive.of(BuildContext context) => AppResponsive._(context);

  bool get isSmallMobile =>
      ResponsiveBreakpoints.of(context).equals(AppBreakpoints.smallMobile);

  bool get isMobile =>
      ResponsiveBreakpoints.of(context).equals(AppBreakpoints.mobile) ||
      isSmallMobile;

  bool get isTablet =>
      ResponsiveBreakpoints.of(context).equals(AppBreakpoints.tablet) ||
      ResponsiveBreakpoints.of(context).largerThan(AppBreakpoints.mobile);

  double get width => MediaQuery.sizeOf(context).width;

  /// Horizontal page padding.
  EdgeInsets get pagePadding {
    if (isSmallMobile) {
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
    return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
  }

  double get sectionGap => isSmallMobile ? 0 : (isTablet ? 10 : 3); // Reduced section gap

  double get featuredCardRadius => isSmallMobile ? 16 : 24;
  double get gridCardRadius => isSmallMobile ? 14 : 20; // Reduced for grid cards

  /// Product / favorites grid columns.
  int get productGridColumns {
    if (isTablet) return width >= 900 ? 4 : 3;
    return 2;
  }

  double get productGridAspectRatio {
    if (isSmallMobile) return 0.62;
    if (isTablet) return 0.72;
    return 0.60; // Taller cards to fit content better
  }

  double get featuredCarouselHeight {
    if (isSmallMobile) return 160;
    if (isTablet) return 205;
    return 170;
  }

  double titleSize(double base) {
    if (isSmallMobile) return base * 0.9;
    if (isTablet) return base * 1.12;
    return base;
  }

  double bodySize(double base) {
    if (isSmallMobile) return base * 0.92;
    if (isTablet) return base * 1.05;
    return base;
  }

  /// Max content width on tablet so lists don't stretch edge-to-edge.
  double get maxContentWidth => isTablet ? 780 : double.infinity;

  /// Bottom inset so scroll content clears the floating glass nav.
  double get bottomNavClearance => isSmallMobile ? 100 : 125; // Slightly increased for safety

  T value<T>({
    required T mobile,
    T? smallMobile,
    T? tablet,
  }) {
    if (isTablet && tablet != null) return tablet;
    if (isSmallMobile && smallMobile != null) return smallMobile;
    return mobile;
  }
}

/// Centers content and clamps width on tablets to avoid stretched overflow layouts.
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool addBottomNavClearance;

  const ResponsivePage({
    super.key,
    required this.child,
    this.padding,
    this.addBottomNavClearance = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final resolvedPadding = padding ?? r.pagePadding;
    final bottomExtra =
        addBottomNavClearance ? r.bottomNavClearance : 0.0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: r.maxContentWidth),
        child: Padding(
          padding: resolvedPadding.add(EdgeInsets.only(bottom: bottomExtra)),
          child: child,
        ),
      ),
    );
  }
}
