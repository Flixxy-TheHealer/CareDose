import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/medicine_model.dart';
import 'add_medicine_screen.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  List<Medicine> get medicines => AppData.todayMedicines;
  void _markTaken(int index) {
    setState(() {
      AppData.todayMedicines[index] = Medicine(
        id: medicines[index].id,
        name: medicines[index].name,
        dosage: medicines[index].dosage,
        description: medicines[index].description,
        time: medicines[index].time,
        status: MedicineStatus.taken,
        iconBgColor: AppColors.successGreen,
        frequency: medicines[index].frequency,
        timings: medicines[index].timings,
        foodInstruction: medicines[index].foodInstruction,
        totalQuantity: medicines[index].totalQuantity,
      );
    });
  }

  void _skipMedicine(int index) {
    setState(() {
      AppData.todayMedicines[index] = Medicine(
        id: medicines[index].id,
        name: medicines[index].name,
        dosage: medicines[index].dosage,
        description: medicines[index].description,
        time: medicines[index].time,
        status: MedicineStatus.skipped,
        iconBgColor: AppColors.skipped,
        frequency: medicines[index].frequency,
        timings: medicines[index].timings,
        foodInstruction: medicines[index].foodInstruction,
        totalQuantity: medicines[index].totalQuantity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasLowStock =
        AppData.inventory.any((i) => i.stockLevel == StockLevel.low);
    final lowStockItem = AppData.inventory.firstWhere(
        (i) => i.stockLevel == StockLevel.low,
        orElse: () => AppData.inventory.first);
    final adherencePercent = medicines.isEmpty
        ? 0
        : (medicines.where((m) => m.status == MedicineStatus.taken).length /
                medicines.length *
                100)
            .round();
    final dosesRemaining = medicines
        .where((m) =>
            m.status != MedicineStatus.taken &&
            m.status != MedicineStatus.skipped)
        .length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text('Good morning, Eleanor!', style: AppTextStyles.heading1),
              const SizedBox(height: 4),
              Text(
                'Here is your schedule for today, March 14th.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 16),
              // Low stock alert
              if (hasLowStock) _buildLowStockAlert(lowStockItem),
              if (hasLowStock) const SizedBox(height: 16),
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '$adherencePercent%',
                      'Adherence Today',
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '$dosesRemaining',
                      'Doses Remaining',
                      AppColors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Today's Medicines
              Text("Today's Medicines", style: AppTextStyles.heading2),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _buildMedicineCard(medicines[i], i),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard-add-medicine',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
          );
          setState(() {});
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.medical_services,
              color: AppColors.primary, size: 22),
        ),
      ),
      title: const Text('CareDose',
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildLowStockAlert(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dangerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.danger, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Low Stock Alert',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.danger, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  'You have only ${item.tabletsLeft} doses of ${item.name} left. Please refill soon.',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: valueColor)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(Medicine med, int index) {
    final isDue = med.status == MedicineStatus.due;
    final isTaken = med.status == MedicineStatus.taken;
    final isSkipped = med.status == MedicineStatus.skipped;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDue ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDue
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isTaken
                          ? AppColors.successGreen
                          : AppColors.skipped.withValues(alpha: 0.2)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isTaken ? Icons.check : Icons.medication,
                  color: isDue
                      ? Colors.white
                      : (isTaken ? Colors.white : AppColors.textSecondary),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Name & dosage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDue ? Colors.white : AppColors.textPrimary,
                        decoration: isTaken
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      med.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDue ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Time & status badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    med.time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDue ? Colors.white : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isDue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Due Now',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    )
                  else if (med.status == MedicineStatus.upcoming)
                    Text('Upcoming',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary))
                  else if (isTaken)
                    Text('Taken',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.successGreen))
                  else if (isSkipped)
                    Text('Skipped',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.skipped)),
                ],
              ),
            ],
          ),
          // Action buttons for due medicine
          if (isDue) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _markTaken(index),
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 16),
                    label: const Text('Mark as Taken',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _skipMedicine(index),
                    icon:
                        const Icon(Icons.block, color: Colors.white, size: 16),
                    label: const Text('Skip',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
