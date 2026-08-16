import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/consts/AppColors.dart';

Widget inputField({
  required BuildContext context,
  required TextEditingController controller,
  required String hint,
  required String label,
  required Color themeColor,
  required bool isDark,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  int? maxLength,
  String Function(String)? formatInput,
  void Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
}) {
  final r = AppResponsive.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.workSans(
          color: themeColor,
          fontSize: r.bodySize(12),
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Container(
        height: r.value(mobile: 52, smallMobile: 44),
        decoration: BoxDecoration(
          color: isDark ? AppColors.instance.shadeblack : AppColors.instance.gray300.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeColor.withOpacity(0.2)),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: GoogleFonts.workSans(color: themeColor, fontWeight: FontWeight.bold, fontSize: r.bodySize(16)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.workSans(color: themeColor.withOpacity(0.3), fontSize: r.bodySize(14)),
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: r.isSmallMobile ? 10 : 14),
          ),
          onChanged: (text) {
            if (formatInput != null) {
              final formattedText = formatInput(text);
              if (formattedText != text) {
                controller.value = controller.value.copyWith(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: formattedText.length),
                );
              }
            }
            if (onChanged != null) onChanged(text);
          },
        ),
      ),
    ],
  );
}
