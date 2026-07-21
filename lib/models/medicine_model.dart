class MedicineModel {
  const MedicineModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.quantity,
    required this.scheduleTimes,
    this.notes,
    this.photoPath,
  });

  final String id;
  final String name;
  final String dosage;
  final int quantity;
  final List<DateTime> scheduleTimes;
  final String? notes;
  final String? photoPath;
}
