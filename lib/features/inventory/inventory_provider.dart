import 'package:flutter/foundation.dart';

class InventoryProvider extends ChangeNotifier {
  int _lowStockCount = 0;

  int get lowStockCount => _lowStockCount;

  void setLowStockCount(int count) {
    _lowStockCount = count;
    notifyListeners();
  }
}
