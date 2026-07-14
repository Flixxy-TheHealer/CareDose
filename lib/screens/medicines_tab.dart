import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/medicine_model.dart';
import 'add_medicine_screen.dart';

class MedicinesTab extends StatefulWidget {
  const MedicinesTab({super.key});
  @override
  State<MedicinesTab> createState() => _MedicinesTabState();
}

class _MedicinesTabState extends State<MedicinesTab> {
  String _filter = 'All';
  final List<String> _filters = ['All', 'Morning', 'Noon', 'Night'];
  @override
  Widget build(BuildContext context) {
    final medicines = AppData.todayMedicines;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('My Medicines', style: AppTextStyles.heading2),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Manage your medication schedule.',
                style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _filter == _filters[i];
                return FilterChip(
                  label: Text(_filters[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = _filters[i]),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: medicines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _buildMedicineListItem(medicines[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'medicines-add-medicine',
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

  Widget _buildMedicineListItem(Medicine med) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: med.iconBgColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication, color: med.iconBgColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: AppTextStyles.heading3),
                Text('${med.dosage} • ${_frequencyLabel(med.frequency)}',
                    style: AppTextStyles.body),
                Text(_timingLabel(med.timings),
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(med.time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              _buildStatusBadge(med.status),
            ],
          ),
        ],
      ),
    );
  }

  String _frequencyLabel(MedicineFrequency f) {
    switch (f) {
      case MedicineFrequency.daily:
        return 'Daily';
      case MedicineFrequency.weekly:
        return 'Weekly';
      case MedicineFrequency.asNeeded:
        return 'As Needed';
    }
  }

  String _timingLabel(List<MedicineTiming> timings) {
    return timings.map((t) {
      switch (t) {
        case MedicineTiming.morning:
          return 'Morning';
        case MedicineTiming.noon:
          return 'Noon';
        case MedicineTiming.night:
          return 'Night';
      }
    }).join(', ');
  }

  Widget _buildStatusBadge(MedicineStatus status) {
    Color color;
    String label;
    switch (status) {
      case MedicineStatus.taken:
        color = AppColors.successGreen;
        label = 'Taken';
        break;
      case MedicineStatus.due:
        color = AppColors.primary;
        label = 'Due';
        break;
      case MedicineStatus.upcoming:
        color = AppColors.textSecondary;
        label = 'Upcoming';
        break;
      case MedicineStatus.skipped:
        color = AppColors.skipped;
        label = 'Skipped';
        break;
      case MedicineStatus.missed:
        color = AppColors.danger;
        label = 'Missed';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
