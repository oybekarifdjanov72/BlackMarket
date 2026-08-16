import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/consts/AppColors.dart';
import '../../../core/consts/AppRouter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        AppRouter.pushReplacement(context, AppRoutes.signIn);
      }
    } catch (e) {
      debugPrint("Splash error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/shopping_cart_logo.png",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Lottie.asset(
              "assets/lottie/splash_animation.json",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.7,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
