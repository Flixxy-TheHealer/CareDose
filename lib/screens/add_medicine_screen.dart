import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/medicine_model.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});
  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  MedicineFrequency _frequency = MedicineFrequency.daily;
  final Set<MedicineTiming> _timings = {MedicineTiming.morning};
  FoodInstruction _foodInstruction = FoodInstruction.afterFood;
  int _quantity = 30;
  void _save() {
    if (_nameController.text.trim().isEmpty ||
        _dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in medicine name and dosage')),
      );
      return;
    }
    final timeStr = _timings.contains(MedicineTiming.morning)
        ? '8:00 AM'
        : _timings.contains(MedicineTiming.noon)
            ? '1:00 PM'
            : '9:00 PM';
    final newMed = Medicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      description:
          '${_dosageController.text.trim()} • ${_foodInstruction == FoodInstruction.afterFood ? 'After meal' : 'Before meal'}',
      time: timeStr,
      status: MedicineStatus.upcoming,
      iconBgColor: AppColors.primary,
      frequency: _frequency,
      timings: _timings.toList(),
      foodInstruction: _foodInstruction,
      totalQuantity: _quantity,
    );
    AppData.todayMedicines.add(newMed);
    AppData.inventory.add(InventoryItem(
      id: newMed.id,
      name: newMed.name,
      dosage: newMed.dosage,
      description: _frequencyLabel(_frequency),
      tabletsLeft: _quantity,
      totalTablets: _quantity,
      stockLevel: StockLevel.good,
      iconBgColor: AppColors.primary,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${_nameController.text.trim()} added successfully!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CareDose',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Medicine', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Enter the details exactly as prescribed.',
                style: AppTextStyles.body),
            const SizedBox(height: 24),
            // Medicine Name
            _buildSectionLabel(Icons.medication_outlined, 'Medicine Name'),
            const SizedBox(height: 8),
            _buildTextField(
                _nameController, 'e.g. Aspirin', TextInputType.text),
            const SizedBox(height: 20),
            // Dosage
            _buildSectionLabel(Icons.science_outlined, 'Dosage'),
            const SizedBox(height: 8),
            _buildTextField(
                _dosageController, 'e.g. 10mg, 1 tablet', TextInputType.text),
            const SizedBox(height: 20),
            // Frequency
            _buildSectionLabel(Icons.calendar_today_outlined, 'Frequency'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: MedicineFrequency.values
                  .map((f) => _buildChoiceChip(
                        label: _frequencyLabel(f),
                        selected: _frequency == f,
                        onTap: () => setState(() => _frequency = f),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Timing
            _buildSectionLabel(Icons.access_time_outlined, 'Timing'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _buildTimingChip('☀️ Morning', MedicineTiming.morning),
                _buildTimingChip('🌤 Noon', MedicineTiming.noon),
                _buildTimingChip('🌙 Night', MedicineTiming.night),
              ],
            ),
            const SizedBox(height: 20),
            // Food Instruction
            _buildSectionLabel(Icons.restaurant_outlined, 'Food Instruction'),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildFoodOption('After Food', FoodInstruction.afterFood),
                const SizedBox(height: 8),
                _buildFoodOption('Before Food', FoodInstruction.beforeFood),
              ],
            ),
            const SizedBox(height: 20),
            // Quantity
            _buildSectionLabel(
                Icons.inventory_2_outlined, 'Total Quantity (Tablets/Pills)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQtyButton(Icons.remove, () {
                    if (_quantity > 1) setState(() => _quantity--);
                  }),
                  const SizedBox(width: 24),
                  Text('$_quantity',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(width: 24),
                  _buildQtyButton(Icons.add, () {
                    setState(() => _quantity++);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined,
                    color: Colors.white, size: 20),
                label: const Text('Save Medicine',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildChoiceChip(
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTimingChip(String label, MedicineTiming timing) {
    final selected = _timings.contains(timing);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            if (_timings.length > 1) _timings.remove(timing);
          } else {
            _timings.add(timing);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodOption(String label, FoodInstruction instruction) {
    final selected = _foodInstruction == instruction;
    return GestureDetector(
      onTap: () => setState(() => _foodInstruction = instruction),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}
