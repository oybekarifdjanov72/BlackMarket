import 'package:flutter/material.dart';

Widget buildQuantityButton(IconData icon, VoidCallback onTap, Color themeColor) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: themeColor.withOpacity(0.8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: themeColor, size: 20),
    ),
  );
}
