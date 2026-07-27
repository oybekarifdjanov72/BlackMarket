import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/consts/AppColors.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onTap, required this.text});
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.instance.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.instance.white, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: const Size(150, 50),
          ),
          child: Text(
            text,
            style: GoogleFonts.workSans(color: AppColors.instance.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
