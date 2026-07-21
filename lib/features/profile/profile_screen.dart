import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('Profile', style: AppTextStyles.heading),
        ),
      ),
    );
  }
}
