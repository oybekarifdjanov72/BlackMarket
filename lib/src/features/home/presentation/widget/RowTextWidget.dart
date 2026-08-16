import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/consts/AppColors.dart';

Widget buildInfoRow(IconData icon, String label, String value, Color themeColor, bool isDark) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: AppColors.instance.cyanAccent,
          size: 28,
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.workSans(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.workSans(
                color: themeColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
