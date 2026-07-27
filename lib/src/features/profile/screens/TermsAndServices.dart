import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/consts/AppColors.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';

class TermsAndServices extends StatelessWidget {
  const TermsAndServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeColor),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Terms and',
                    style: GoogleFonts.workSans(
                      color: themeColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                    text: ' Services',
                    style: GoogleFonts.workSans(
                      color: AppColors.instance.cyanAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Updated: June 18, 2025',
                  style: GoogleFonts.workSans(
                    color: AppColors.instance.gray, 
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSectionTitle('1. Acceptance of Terms', themeColor),
                _buildSectionText(
                  'By accessing or using our services, you agree to be bound by these Terms.',
                  themeColor,
                ),

                const SizedBox(height: 30),
                _buildSectionTitle('2. User Responsibilities', themeColor),
                _buildSectionText(
                  'You agree not to use the service for any unlawful purpose or in any way that might harm, damage, or disparage any other party.',
                  themeColor,
                ),

                const SizedBox(height: 30),
                _buildSectionTitle('3. Privacy Policy', themeColor),
                _buildSectionText(
                  'Your use of our services is also governed by our Privacy Policy, which explains how we collect, use and protect your information.',
                  themeColor,
                ),

                const SizedBox(height: 30),
                _buildSectionTitle('4. Modifications', themeColor),
                _buildSectionText(
                  'We reserve the right to modify these terms at any time. Your continued use of the service constitutes acceptance of the modified terms.',
                  themeColor,
                ),

                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      side: BorderSide(color: themeColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt_outlined, size: 24, color: themeColor),
                        const SizedBox(width: 10),
                        Text(
                          'I UNDERSTAND', 
                          style: GoogleFonts.workSans(
                            color: themeColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.workSans(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.workSans(
        color: color.withOpacity(0.9),
        fontSize: 18, 
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
