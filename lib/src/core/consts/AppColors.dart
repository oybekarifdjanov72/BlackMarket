import 'package:flutter/material.dart';

class AppColors {
  static final AppColors instance = AppColors._internal();
  AppColors._internal();

  final Color golden = const Color(0XFFE2F163);
  final Color white = const Color(0XFFFFFFFF);
  final Color black = const Color(0XFF000000);
  final Color regular = const Color(0xffB39DFF);
  final Color yellow = const Color(0xffFFEB3B);
  final Color white54 = const Color(0x9AFFFFFF);
  final Color purpleAccent = const Color(0XFFB3A0FF);
  final Color randomColor = const Color(0XFF696969);
  final Color purple = const Color(0XFF896CFE);
  final Color shadeblack = const Color(0XFF232323);
  final Color gray = const Color(0xFF9E9E9E);
  final Color gray300 = const Color(0xFFE0E0E0);
  final Color cyanAccent = const Color(0xFF00E5FF);
  final Color red = const Color(0xFFFF5252);
  final Color greenAccent = const Color(0xFF69F0AE);

  Color getBackground(bool isDark) => isDark ? black : const Color(0xFFF5F5F5);
  Color getTextPrimary(bool isDark) => isDark ? white : black;
  Color getTextSecondary(bool isDark) => isDark ? white54 : Colors.black54;
  Color getCardBackground(bool isDark) => isDark ? shadeblack : white;
  Color getBorderColor(bool isDark) => isDark ? white : black;
}
