import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/consts/AppColors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/404 1.png",

            ),
            const SizedBox(height: 20),
             Text(
              "Oops! Nothing here",
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
