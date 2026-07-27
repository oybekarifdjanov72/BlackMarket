import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/consts/AppColors.dart';
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: themeColor, size: 35),
          title: Text(
            text,
            style: GoogleFonts.workSans(
              color: themeColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios, 
            color: themeColor,
            size: 20,
          ),
          onTap: onTap,
        );
      },
    );
  }
}
