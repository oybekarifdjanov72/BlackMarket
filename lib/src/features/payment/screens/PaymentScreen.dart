import 'package:black_market/src/core/widget/SmoothEntryAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import '../../../core/consts/AppColors.dart';
import '../../../core/consts/AppRouter.dart';
import '../../basket/cubit/BasketCubit.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';
import '../widget/InputFieldWidget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(() => setState(() {}));
    cardHolderController.addListener(() => setState(() {}));
    expiryController.addListener(() => setState(() {}));
    cvcController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvcController.dispose();
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

        final screenHeight = MediaQuery.sizeOf(context).height;
        final cardWidth = (MediaQuery.sizeOf(context).width * 0.85).clamp(0.0, 450.0);
        final cardHeight = cardWidth * 0.6;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: themeColor, size: 22,),
              onPressed: () => Navigator.pop(context),
            ),
            title: SmoothEntryAnimation(
              slideOffset: const Offset(0, -20),
              child: Text(
                "Payment",
                style: GoogleFonts.workSans(
                  color: AppColors.instance.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: r.titleSize(24),
                  shadows: [
                    Shadow(
                      color: AppColors.instance.cyanAccent.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: ResponsivePage(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        SmoothEntryAnimation(
                          slideOffset: const Offset(0, 40),
                          child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/image/credit-card.png',
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.8,
                                ),
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [AppColors.instance.shadeblack, Colors.black]
                                      : [AppColors.instance.gray300, AppColors.instance.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ]
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: cardHeight * 0.55,
                                  left: 20,
                                  right: 20,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      cardNumberController.text.isEmpty
                                          ? 'XXXX XXXX XXXX XXXX'
                                          : cardNumberController.text,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.workSans(
                                        color: isDark ? Colors.white : Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CARD HOLDER',
                                        style: GoogleFonts.workSans(
                                          color: isDark ? Colors.white54 : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        cardHolderController.text.isEmpty
                                            ? 'NAME SURNAME'
                                            : cardHolderController.text.toUpperCase(),
                                        style: GoogleFonts.workSans(
                                          color: isDark ? Colors.white : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'EXPIRES',
                                        style: GoogleFonts.workSans(
                                          color: isDark ? Colors.white54 : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        expiryController.text.isEmpty
                                            ? 'MM/YY'
                                            : expiryController.text,
                                        style: GoogleFonts.workSans(
                                          color: isDark ? Colors.white : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SmoothEntryAnimation(
                            delay: const Duration(milliseconds: 300),
                            child: Column(
                              children: [
                                inputField(
                                  context: context,
                                  controller: cardNumberController,
                                  hint: "1234 5678 9012 3456",
                                  label: "CARD NUMBER",
                                  keyboardType: TextInputType.number,
                                  maxLength: 19,
                                  formatInput: _formatCardNumber,
                                  themeColor: themeColor,
                                  isDark: isDark,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: inputField(
                                        context: context,
                                        controller: expiryController,
                                        hint: "MM/YY",
                                        label: "EXPIRY DATE",
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        themeColor: themeColor,
                                        isDark: isDark,
                                        onChanged: (text) {
                                          final formattedText = _formatExpiryDate(text);
                                          if (formattedText != text) {
                                            expiryController.value = expiryController.value.copyWith(
                                              text: formattedText,
                                              selection: TextSelection.collapsed(offset: formattedText.length),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 1,
                                      child: inputField(
                                        context: context,
                                        controller: cvcController,
                                        hint: "CVC",
                                        label: "CVC",
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        maxLength: 3,
                                        themeColor: themeColor,
                                        isDark: isDark,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                inputField(
                                  context: context,
                                  controller: cardHolderController,
                                  hint: "Card Holder Name",
                                  label: "CARD HOLDER",
                                  themeColor: themeColor,
                                  isDark: isDark,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SmoothEntryAnimation(
                        delay: const Duration(milliseconds: 600),
                        slideOffset: const Offset(0, 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                            if (_validateInputs()) {
                              await context.read<BasketCubit>().checkout();
                              if (mounted) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  title: Text(
                                    'Purchase Confirmed',
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  autoCloseDuration: const Duration(seconds: 3),
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  AppRouter.pushAndRemoveUntil(
                                    context,
                                    AppRoutes.bottomNav,
                                    (route) => false,
                                  );
                                });
                              }
                            }
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppColors.instance.white : AppColors.instance.black,
                              padding: EdgeInsets.symmetric(vertical: r.isSmallMobile ? 14 : 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Confirm Payment",
                              style: GoogleFonts.workSans(
                                fontSize: r.bodySize(18),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatCardNumber(String text) {
    text = text.replaceAll(RegExp(r'\s'), '');
    var result = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) result += ' ';
      result += text[i];
    }
    return result;
  }

  String _formatExpiryDate(String text) {
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length >= 2) {
      return '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return text;
  }

  bool _validateInputs() {
    if (cardNumberController.text.length < 19) {
      toastification.show(
        type: ToastificationType.error,
        title: Text(
          "Please enter valid 16-digit card number!",
          style: GoogleFonts.workSans(
            fontSize: 16,
            color: AppColors.instance.black,
          ),
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return false;
    }
    if (expiryController.text.length != 5) {
      toastification.show(
        type: ToastificationType.error,
        title: Text(
          "Please enter a valid expiry date (MM/YY)",
          style: GoogleFonts.workSans(
            fontSize: 16,
            color: AppColors.instance.black,
          ),
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return false;
    }
    if (cvcController.text.length != 3) {
      toastification.show(
        type: ToastificationType.error,
        title: Text(
          "Please enter valid 3-digit CVC!",
          style: GoogleFonts.workSans(
            fontSize: 16,
            color: AppColors.instance.black,
          ),
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return false;
    }
    if (cardHolderController.text.isEmpty) {
      toastification.show(
        type: ToastificationType.error,
        title: Text(
          "Please enter valid card holder name!",
          style: GoogleFonts.workSans(
            fontSize: 16,
            color: AppColors.instance.black,
          ),
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return false;
    }
    return true;
  }
}
