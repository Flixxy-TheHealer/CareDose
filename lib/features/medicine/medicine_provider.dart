import 'package:flutter/foundation.dart';

import '../../models/medicine_model.dart';

class MedicineProvider extends ChangeNotifier {
  final List<MedicineModel> _medicines = [];

  List<MedicineModel> get medicines => List.unmodifiable(_medicines);

  void addMedicine(MedicineModel medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }
}
