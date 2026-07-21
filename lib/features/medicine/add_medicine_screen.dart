import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('Add Medicine', style: AppTextStyles.heading),
        ),
      ),
    );
  }
}
