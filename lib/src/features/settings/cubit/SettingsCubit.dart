import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/NotificationSettingsManager.dart';
import 'SettingsState.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const String _themeKey = 'is_dark_mode';

  SettingsCubit() : super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = await NotificationSettingsManager.getNotificationsEnabled();
    final isDarkMode = prefs.getBool(_themeKey) ?? true;
    
    emit(state.copyWith(
      notificationsEnabled: notificationsEnabled,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> toggleNotifications(bool value) async {
    await NotificationSettingsManager.setNotificationsEnabled(value);
    emit(state.copyWith(notificationsEnabled: value));
  }

  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    emit(state.copyWith(isDarkMode: value));
  }

  Future<void> reportBug(String description) async {
    if (description.isEmpty) return;

    emit(state.copyWith(status: SettingsStatus.loading));
    
    const String botToken = '8195029792:AAGSYJtE6cOw8sCM6dsSZF5W9xllFZ_PtNE';
    const String chatId = '5045578026';
    final String text = Uri.encodeFull("🐞 Bug Report:\n$description");
    final url = 'https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=$text';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        emit(state.copyWith(status: SettingsStatus.success, bugReportStatus: 'Bug reported successfully'));
      } else {
        emit(state.copyWith(status: SettingsStatus.error, errorMessage: 'Failed to send bug report'));
      }
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error, errorMessage: 'Error sending bug report'));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: SettingsStatus.initial, bugReportStatus: null, errorMessage: null));
  }
}
