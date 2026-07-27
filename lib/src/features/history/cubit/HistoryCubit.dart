import 'package:bloc/bloc.dart';
import '../widget/PurchaseHistoryManager.dart';
import 'HistoryState.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final history = await PurchaseHistoryManager.getHistory();
      emit(state.copyWith(
        status: HistoryStatus.success,
        history: history.reversed.toList(),
      ));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.error, errorMessage: e.toString()));
    }
  }
}
