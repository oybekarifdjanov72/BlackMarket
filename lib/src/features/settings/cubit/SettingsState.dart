import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, success, error }

class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool isDarkMode;
  final SettingsStatus status;
  final String? errorMessage;
  final String? bugReportStatus;

  const SettingsState({
    this.notificationsEnabled = true,
    this.isDarkMode = true,
    this.status = SettingsStatus.initial,
    this.errorMessage,
    this.bugReportStatus,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? isDarkMode,
    SettingsStatus? status,
    String? errorMessage,
    String? bugReportStatus,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      bugReportStatus: bugReportStatus ?? this.bugReportStatus,
    );
  }

  @override
  List<Object?> get props => [notificationsEnabled, isDarkMode, status, errorMessage, bugReportStatus];
}
