import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  int _todayDoseCount = 0;

  int get todayDoseCount => _todayDoseCount;

  void setTodayDoseCount(int count) {
    _todayDoseCount = count;
    notifyListeners();
  }
}
