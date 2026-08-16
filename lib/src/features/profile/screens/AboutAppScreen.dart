import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/consts/AppColors.dart';
import '../../settings/cubit/SettingsCubit.dart';
import '../../settings/cubit/SettingsState.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'About ',
                    style: GoogleFonts.workSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: themeColor.withOpacity(0.8),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: 'App',
                    style: GoogleFonts.workSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.cyanAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: AppColors.instance.cyanAccent.withOpacity(0.8),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    'This app is designed to make your life easier by providing amazing features... \n\nThis fantastic app made by @animeshnik72, all the product sertificated and high quality for cheap cost. \n\nYou can buy every type of clothes to wearing, if you want to sent ideas for development, \n\nLeave your idea here \nTelegram: @slutstain, \nTelegram Bot: @blackmarket72bot \nInstagram: @slutstain_edits',
                    style: GoogleFonts.workSans(fontSize: 18, color: themeColor),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Why Choose Black Market?",
                    style: GoogleFonts.workSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Security First: \nYour privacy and security are our top priority. \nOur app uses the latest encryption technologies to ensure your personal information and payment details are kept safe. \n\nAffordable Prices: \nWe strive to offer competitive prices so that you can enjoy top-quality products without breaking the bank. \n\n24/7 Customer Support: \nIf you ever have any questions or issues, our dedicated support team is available around the clock to assist you.',
                    style: GoogleFonts.workSans(fontSize: 18, color: themeColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
