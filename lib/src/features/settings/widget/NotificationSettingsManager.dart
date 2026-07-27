import 'package:shared_preferences/shared_preferences.dart';
class NotificationSettingsManager {
  static const String _key = 'notifications_enabled';

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }
}
