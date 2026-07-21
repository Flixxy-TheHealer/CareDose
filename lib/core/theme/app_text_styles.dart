import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.inter,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.inter,
    color: AppColors.textPrimary,
  );

  static const TextStyle secondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.inter,
    color: AppColors.textSecondary,
  );

  static const TextStyle stat = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.inter,
    color: AppColors.textPrimary,
  );
}
