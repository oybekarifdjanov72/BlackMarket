import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/consts/AppColors.dart';
import '../cubit/HistoryCubit.dart';
import '../cubit/HistoryState.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(),
      child: const PurchaseHistoryView(),
    );
  }
}

class PurchaseHistoryView extends StatelessWidget {
  const PurchaseHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);
        final cardColor = AppColors.instance.getCardBackground(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                style: GoogleFonts.workSans(fontSize: 24, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Purchases ',
                    style: TextStyle(
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
                    text: 'History',
                    style: TextStyle(
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
            backgroundColor: bgColor,
            foregroundColor: themeColor,
          ),
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state.status == HistoryStatus.loading) {
                return Center(child: CircularProgressIndicator(color: AppColors.instance.cyanAccent));
              }

              if (state.status == HistoryStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? "Error loading history",
                    style: GoogleFonts.workSans(color: themeColor),
                  ),
                );
              }

              if (state.history.isEmpty) {
                return Center(
                  child: Text(
                    "No purchase history yet.",
                    style: GoogleFonts.workSans(
                      color: themeColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.history.length,
                itemBuilder: (context, index) {
                  final item = state.history[index];
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.item.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.image_not_supported, color: themeColor),
                        ),
                      ),
                      title: Text(
                        item.item.title,
                        style: GoogleFonts.workSans(
                          color: themeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'By ${item.item.brand}\nBought on: ${DateFormat('yyyy-MM-dd – kk:mm').format(item.purchaseDate)}',
                        style: GoogleFonts.workSans(color: themeColorSecondary, fontSize: 14),
                      ),
                      trailing: Text(
                        "\$${item.item.price}",
                        style: GoogleFonts.workSans(
                          color: AppColors.instance.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: AppColors.instance.red.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
