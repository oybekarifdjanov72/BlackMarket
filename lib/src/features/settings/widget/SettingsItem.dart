import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/consts/AppColors.dart';
import '../cubit/SettingsCubit.dart';
import '../cubit/SettingsState.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: themeColor, size: r.value(mobile: 35, smallMobile: 30)),
          title: Text(
            text,
            style: GoogleFonts.workSans(
              color: themeColor,
              fontSize: r.bodySize(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios, 
            color: themeColor,
            size: r.value(mobile: 20, smallMobile: 18),
          ),
          onTap: onTap,
        );
      },
    );
  }
}
