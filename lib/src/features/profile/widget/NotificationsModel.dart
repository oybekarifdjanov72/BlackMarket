import 'dart:convert';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/consts/AppColors.dart';

class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const _storageKey = 'notifications';
  List<AppNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_storageKey) ?? [];

    setState(() {
      notifications = rawList
          .map((e) => AppNotification.fromJson(jsonDecode(e)))
          .toList();
      isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    setState(() {
      notifications.clear();
    });
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
            iconTheme: IconThemeData(color: themeColor),
            title: Text(
              'Notifications',
              style: GoogleFonts.workSans(
                color: AppColors.instance.cyanAccent, 
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: AppColors.instance.cyanAccent.withOpacity(0.8),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            actions: [
              if (notifications.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _clearAll,
                  tooltip: 'Clear all',
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
                : notifications.isEmpty
                ? Center(
              child: Text(
                'No notifications yet',
                style: GoogleFonts.workSans(
                  color: themeColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: themeColor.withOpacity(0.5),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _NotificationCard(notification: n);
              },
            ),
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<SettingsCubit>().state.isDarkMode;
    final themeColor = AppColors.instance.getTextPrimary(isDark);
    final themeColorSecondary = AppColors.instance.getTextSecondary(isDark);
    final cardColor = AppColors.instance.getCardBackground(isDark);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: GoogleFonts.workSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
              Icon(
                notification.isRead
                    ? Icons.notifications_none
                    : Icons.notifications_active,
                color: AppColors.instance.cyanAccent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.description,
            style: GoogleFonts.workSans(
              fontSize: 14,
              color: themeColorSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _formatDate(notification.date),
              style: GoogleFonts.workSans(
                fontSize: 12,
                color: themeColorSecondary.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
