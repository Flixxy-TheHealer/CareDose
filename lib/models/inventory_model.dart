class InventoryModel {
  const InventoryModel({
    required this.medicineId,
    required this.currentQuantity,
    required this.lowStockThreshold,
  });

  final String medicineId;
  final int currentQuantity;
  final int lowStockThreshold;

  bool get isLowStock => currentQuantity <= lowStockThreshold;
}
