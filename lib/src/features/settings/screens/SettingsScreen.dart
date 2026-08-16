import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/consts/AppColors.dart';
import '../../report/widget/BugReportWidget.dart';
import '../cubit/SettingsCubit.dart';
import '../cubit/SettingsState.dart';
import '../widget/SettingsItem.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: bgColor,
            elevation: 0,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'General ',
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
                    text: 'Settings',
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
            centerTitle: true,
          ),
          backgroundColor: bgColor,
          body: ResponsivePage(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.value(mobile: 10.0, tablet: 0.0),
                  vertical: r.value(mobile: 12.0, smallMobile: 8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsItem(
                      icon: Icons.person_2_outlined,
                      text: "Account",
                      onTap: () => AppRouter.push(context, AppRoutes.profile),
                    ),
                    SizedBox(height: r.sectionGap),
                    SettingsItem(
                      icon: Icons.location_on_outlined,
                      text: "Location",
                      onTap: () => AppRouter.push(context, AppRoutes.mapScreen),
                    ),
                    SizedBox(height: r.sectionGap),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isDark,
                      onChanged: (value) {
                        context.read<SettingsCubit>().toggleTheme(value);
                      },
                      activeThumbColor: themeColor,
                      activeTrackColor: AppColors.instance.greenAccent,
                      inactiveThumbColor: themeColor,
                      inactiveTrackColor: AppColors.instance.gray,
                      title: Text(
                        'Dark Mode',
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: r.bodySize(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        isDark ? 'On' : 'Off',
                        style: GoogleFonts.workSans(
                          color: themeColor.withOpacity(0.7),
                          fontSize: r.bodySize(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      secondary: Icon(
                        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                        color: themeColor,
                        size: r.value(mobile: 35, smallMobile: 30),
                      ),
                    ),
                    SizedBox(height: r.sectionGap),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: state.notificationsEnabled,
                      onChanged: (value) {
                        context.read<SettingsCubit>().toggleNotifications(value);
                      },
                      activeThumbColor: themeColor,
                      activeTrackColor: AppColors.instance.greenAccent,
                      inactiveThumbColor: themeColor,
                      inactiveTrackColor: AppColors.instance.gray,
                      title: Text(
                        'Notifications',
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: r.bodySize(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        state.notificationsEnabled ? 'On' : 'Off',
                        style: GoogleFonts.workSans(
                          color: themeColor.withOpacity(0.7),
                          fontSize: r.bodySize(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      secondary: Icon(
                        state.notificationsEnabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        color: themeColor,
                        size: r.value(mobile: 35, smallMobile: 30),
                      ),
                    ),
                    SizedBox(height: r.sectionGap * 2),
                    Divider(
                      height: 1.5,
                      thickness: 1.5,
                      color: themeColor.withOpacity(0.3),
                    ),
                    SizedBox(height: r.sectionGap * 2),
                    SettingsItem(
                      icon: Icons.description_outlined,
                      text: "Terms and Services",
                      onTap: () => AppRouter.push(context, AppRoutes.termsAndServices),
                    ),
                    SizedBox(height: r.sectionGap),
                    SettingsItem(
                      icon: Icons.info_outline,
                      text: "About App",
                      onTap: () => AppRouter.push(context, AppRoutes.aboutApp),
                    ),
                    SizedBox(height: r.sectionGap),
                    SettingsItem(
                      icon: Icons.bug_report_outlined,
                      text: "Report Bugs",
                      onTap: () {
                        showBugReportDialog(context, context.read<SettingsCubit>());
                      },
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
