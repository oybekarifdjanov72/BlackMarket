import 'package:black_market/src/features/basket/cubit/BasketCubit.dart';
import 'package:black_market/src/features/basket/cubit/BasketState.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/consts/AppColors.dart';
import '../../../core/utils/consts/AppRouter.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage>
    with SingleTickerProviderStateMixin {
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: Text("Could not open dialer", style: GoogleFonts.workSans(fontSize: 18, fontWeight: FontWeight.bold),),
        );
      }
    }
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);
        final containerColor = AppColors.instance.getCardBackground(isDark);

        return BlocBuilder<BasketCubit, BasketState>(
          builder: (context, basketState) {
            final items = basketState.items;
            final total = basketState.totalPrice;

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                leading: BackButton(color: themeColor),
                backgroundColor: bgColor,
                elevation: 0,
                centerTitle: true,
                title: RichText(
                  text: TextSpan(
                    style: GoogleFonts.workSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: "Delivery ", style: TextStyle(color: themeColor)),
                      TextSpan(
                        text: "Details",
                        style: TextStyle(
                          color: AppColors.instance.cyanAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
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
              body: Column(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _animation,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/image/paper-fibers.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                          color: AppColors.instance.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.receipt_long, color: AppColors.instance.black),
                                const SizedBox(width: 8),
                                Text(
                                  "Your Receipt",
                                  style: GoogleFonts.workSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.instance.black,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1.5, color: AppColors.instance.black.withOpacity(0.2)),
                            Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final basketItem = items[index];
                                  final product = basketItem.product;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product.title,
                                                style: GoogleFonts.workSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: AppColors.instance.black,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "x${basketItem.quantity}",
                                              style: GoogleFonts.workSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.brand,
                                          style: GoogleFonts.workSans(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        Divider(thickness: 2, color: AppColors.instance.gray.withOpacity(0.15)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(thickness: 2, color: AppColors.instance.black.withOpacity(0.8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: AppColors.instance.black,
                                  ),
                                ),
                                Text(
                                  "\$${total.toStringAsFixed(2)}",
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: themeColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Deliver:",
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.instance.white,
                              child: const Icon(CupertinoIcons.person, size: 28,),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Oybek",
                                  style: GoogleFonts.workSans(
                                    color: themeColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Courier - ETA: 15-20 mins",
                                  style: GoogleFonts.workSans(color: themeColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () => _makePhoneCall('+998935161193'),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.instance.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.phone, color: isDark ? AppColors.instance.black : AppColors.instance.white, size: 30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<BasketCubit>().checkout();

                        if (mounted) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            title: Text(
                              'Purchase Confirmed ✅',
                              style: GoogleFonts.workSans(fontWeight: FontWeight.bold),
                            ),
                            autoCloseDuration: const Duration(seconds: 3),
                          );

                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              AppRouter.pushAndRemoveUntil(
                                context,
                                AppRoutes.bottomNav,
                                (route) => false,
                              );
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.instance.white : AppColors.instance.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "CONFIRM PURCHASE",
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.instance.black : AppColors.instance.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
