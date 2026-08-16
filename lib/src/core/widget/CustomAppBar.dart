import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/AppColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
        this.isLeading = false,
        required this.title,
        this.actions = const [],
        this.isDark = false});
  final String title;
  final List<Widget> actions;
  final bool isLeading;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: isDark == true ? AppColors.instance.black : AppColors.instance.white,
      centerTitle: true,
      actions: actions,
      leading: isLeading == true ? IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, size: 30, color: AppColors.instance.white,)) : null,
      title: Text(
        title,
        style: GoogleFonts.workSans(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.instance.white),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight.toDouble());
}