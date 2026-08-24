import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:black_market/src/core/widget/SmoothEntryAnimation.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/consts/AppColors.dart';
import '../../../core/consts/AppRouter.dart';
import '../../basket/cubit/BasketCubit.dart';
import '../../basket/cubit/BasketState.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open dialer")));
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
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
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
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back, size: 24, color: themeColor),
                ),
                backgroundColor: bgColor,
                elevation: 0,
                centerTitle: true,
                title: SmoothEntryAnimation(
                  slideOffset: const Offset(0, -20),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.workSans(
                        fontSize: r.titleSize(24),
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Delivery ",
                          style: TextStyle(color: themeColor),
                        ),
                        TextSpan(
                          text: "Details",
                          style: TextStyle(
                            color: AppColors.instance.cyanAccent,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: AppColors.instance.cyanAccent.withOpacity(
                                  0.8,
                                ),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: ResponsivePage(
                child: Column(
                  children: [
                    Expanded(
                      child: SmoothEntryAnimation(
                        slideOffset: const Offset(0, 30),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(r.isSmallMobile ? 12 : 16),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/image/paper-fibers.png",
                              ),
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
                                  Icon(
                                    Icons.receipt_long,
                                    color: AppColors.instance.black,
                                    size: r.isSmallMobile ? 18 : 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Your Receipt",
                                    style: GoogleFonts.workSans(
                                      fontSize: r.bodySize(20),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.instance.black,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1.5,
                                color: AppColors.instance.black.withOpacity(
                                  0.2,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final basketItem = items[index];
                                    final product = basketItem.product;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: product.title,
                                                        style:
                                                            GoogleFonts.workSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: r
                                                                  .bodySize(18),
                                                              color: AppColors
                                                                  .instance
                                                                  .black,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            " x${basketItem.quantity}",
                                                        style:
                                                            GoogleFonts.workSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: r
                                                                  .bodySize(16),
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              Text(
                                                "\$${(product.price * basketItem.quantity).toStringAsFixed(2)}",
                                                style: GoogleFonts.workSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: r.bodySize(17),
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            product.brand,
                                            style: GoogleFonts.workSans(
                                              color: Colors.grey[700],
                                              fontSize: r.bodySize(14),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color: AppColors.instance.gray
                                                .withOpacity(0.15),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.instance.black.withOpacity(
                                  0.8,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total:",
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: r.bodySize(20),
                                      color: AppColors.instance.black,
                                    ),
                                  ),
                                  Text(
                                    "\$${total.toStringAsFixed(2)}",
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: r.bodySize(20),
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SmoothEntryAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(r.isSmallMobile ? 12 : 16),
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
                                  fontSize: r.bodySize(20),
                                  fontWeight: FontWeight.bold,
                                  color: themeColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: r.isSmallMobile ? 24 : 30,
                                  backgroundColor: AppColors.instance.white,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    size: r.isSmallMobile ? 22 : 28,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Oybek",
                                        style: GoogleFonts.workSans(
                                          color: themeColor,
                                          fontSize: r.bodySize(18),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Courier - ETA: 15-20 mins",
                                        style: GoogleFonts.workSans(
                                          color: themeColor.withOpacity(0.7),
                                          fontSize: r.bodySize(13),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () => _makePhoneCall('+998935161193'),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.instance.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.phone,
                                      color: isDark ? Colors.black : Colors.white,
                                      size: r.isSmallMobile ? 24 : 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SmoothEntryAnimation(
                      delay: const Duration(milliseconds: 400),
                      slideOffset: const Offset(0, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            AppRouter.push(
                              context,
                              AppRoutes.payment,
                            );
                          }
                        },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.instance.white
                                : AppColors.instance.black,
                            padding: EdgeInsets.symmetric(
                              vertical: r.isSmallMobile ? 14 : 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "CONFIRM PURCHASE",
                            style: GoogleFonts.workSans(
                              fontSize: r.bodySize(18),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
