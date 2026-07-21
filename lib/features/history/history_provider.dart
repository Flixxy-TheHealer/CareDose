import 'package:flutter/foundation.dart';

class HistoryProvider extends ChangeNotifier {
  int _completedDoseCount = 0;

  int get completedDoseCount => _completedDoseCount;

  void setCompletedDoseCount(int count) {
    _completedDoseCount = count;
    notifyListeners();
  }
}
