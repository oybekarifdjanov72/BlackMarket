import 'package:equatable/equatable.dart';
import '../widget/PurchaseHistoryManager.dart';

enum HistoryStatus { initial, loading, success, error }

class HistoryState extends Equatable {
  final List<PurchaseHistoryItem> history;
  final HistoryStatus status;
  final String? errorMessage;

  const HistoryState({
    this.history = const [],
    this.status = HistoryStatus.initial,
    this.errorMessage,
  });

  HistoryState copyWith({
    List<PurchaseHistoryItem>? history,
    HistoryStatus? status,
    String? errorMessage,
  }) {
    return HistoryState(
      history: history ?? this.history,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [history, status, errorMessage];
}
