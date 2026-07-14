import 'package:flutter/material.dart';
enum MedicineStatus { taken, upcoming, due, skipped, missed }
enum StockLevel { good, low, planSoon }
enum MedicineFrequency { daily, weekly, asNeeded }
enum MedicineTiming { morning, noon, night }
enum FoodInstruction { afterFood, beforeFood }
class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String description;
  final String time;
  final MedicineStatus status;
  final String iconType;
  final Color iconBgColor;
  final MedicineFrequency frequency;
  final List<MedicineTiming> timings;
  final FoodInstruction foodInstruction;
  int totalQuantity;
  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.description,
    required this.time,
    required this.status,
    this.iconType = 'pill',
    this.iconBgColor = const Color(0xFF1A56DB),
    this.frequency = MedicineFrequency.daily,
    this.timings = const [MedicineTiming.morning],
    this.foodInstruction = FoodInstruction.afterFood,
    this.totalQuantity = 30,
  });
}
class InventoryItem {
  final String id;
  final String name;
  final String dosage;
  final String description;
  final int tabletsLeft;
  final int totalTablets;
  final StockLevel stockLevel;
  final Color iconBgColor;
  InventoryItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.description,
    required this.tabletsLeft,
    required this.totalTablets,
    required this.stockLevel,
    this.iconBgColor = const Color(0xFF10B981),
  });
  double get stockPercentage => tabletsLeft / totalTablets;
  String get stockLabel {
    switch (stockLevel) {
      case StockLevel.good:
        return 'Good Stock';
      case StockLevel.low:
        return 'Low Stock!';
      case StockLevel.planSoon:
        return 'Plan Refill Soon';
    }
  }
  Color get stockColor {
    switch (stockLevel) {
      case StockLevel.good:
        return const Color(0xFF057A55);
      case StockLevel.low:
        return const Color(0xFFE02424);
      case StockLevel.planSoon:
        return const Color(0xFFD97706);
    }
  }
  Color get progressColor {
    switch (stockLevel) {
      case StockLevel.good:
        return const Color(0xFF10B981);
      case StockLevel.low:
        return const Color(0xFFE02424);
      case StockLevel.planSoon:
        return const Color(0xFFD97706);
    }
  }
}
class DoseRecord {
  final String medicineName;
  final String dosage;
  final String time;
  final MedicineStatus status;
  DoseRecord({
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.status,
  });
}
// Sample data
class AppData {
  static List<Medicine> todayMedicines = [
    Medicine(
      id: '1',
      name: 'Atorvastatin',
      dosage: '20mg',
      description: '20mg • Take with food',
      time: '8:00 AM',
      status: MedicineStatus.due,
      iconBgColor: const Color(0xFF1A56DB),
      frequency: MedicineFrequency.daily,
      timings: [MedicineTiming.morning],
      foodInstruction: FoodInstruction.afterFood,
      totalQuantity: 30,
    ),
    Medicine(
      id: '2',
      name: 'Metformin',
      dosage: '500mg',
      description: '500mg • After meal',
      time: '1:00 PM',
      status: MedicineStatus.upcoming,
      iconBgColor: const Color(0xFF9CA3AF),
      frequency: MedicineFrequency.daily,
      timings: [MedicineTiming.noon],
      foodInstruction: FoodInstruction.afterFood,
      totalQuantity: 60,
    ),
    Medicine(
      id: '3',
      name: 'Lisinopril',
      dosage: '10mg',
      description: '10mg',
      time: '7:00 AM',
      status: MedicineStatus.taken,
      iconBgColor: const Color(0xFF10B981),
      frequency: MedicineFrequency.daily,
      timings: [MedicineTiming.morning],
      foodInstruction: FoodInstruction.beforeFood,
      totalQuantity: 60,
    ),
  ];
  static List<InventoryItem> inventory = [
    InventoryItem(
      id: '1',
      name: 'Lisinopril',
      dosage: '10mg',
      description: 'Daily Blood Pressure',
      tabletsLeft: 45,
      totalTablets: 60,
      stockLevel: StockLevel.good,
      iconBgColor: const Color(0xFF10B981),
    ),
    InventoryItem(
      id: '2',
      name: 'Atorvastatin',
      dosage: '20mg',
      description: 'Evening Cholesterol',
      tabletsLeft: 3,
      totalTablets: 30,
      stockLevel: StockLevel.low,
      iconBgColor: const Color(0xFFE02424),
    ),
    InventoryItem(
      id: '3',
      name: 'Metformin',
      dosage: '500mg',
      description: 'Twice Daily',
      tabletsLeft: 14,
      totalTablets: 60,
      stockLevel: StockLevel.planSoon,
      iconBgColor: const Color(0xFF1A56DB),
    ),
  ];
  static List<DoseRecord> recentDoses = [
    DoseRecord(
      medicineName: 'Lisinopril 10mg',
      dosage: 'Today, 8:00 AM',
      time: 'Today',
      status: MedicineStatus.taken,
    ),
    DoseRecord(
      medicineName: 'Metformin 500mg',
      dosage: 'Yesterday, 9:00 PM',
      time: 'Yesterday',
      status: MedicineStatus.taken,
    ),
    DoseRecord(
      medicineName: 'Atorvastatin 20mg',
      dosage: 'Thursday, 9:00 PM',
      time: 'Thursday',
      status: MedicineStatus.missed,
    ),
    DoseRecord(
      medicineName: 'Vitamin D3',
      dosage: 'Sunday, 10:00 AM',
      time: 'Sunday',
      status: MedicineStatus.skipped,
    ),
  ];
  // Weekly adherence data for chart [taken, missed, skipped] per day
  static List<Map<String, int>> weeklyData = [
    {'taken': 3, 'missed': 0, 'skipped': 0}, // Mon
    {'taken': 2, 'missed': 1, 'skipped': 0}, // Tue
    {'taken': 3, 'missed': 0, 'skipped': 0}, // Wed
    {'taken': 2, 'missed': 0, 'skipped': 1}, // Thu
    {'taken': 3, 'missed': 0, 'skipped': 0}, // Fri
    {'taken': 2, 'missed': 1, 'skipped': 0}, // Sat
    {'taken': 3, 'missed': 0, 'skipped': 0}, // Sun
  ];
}