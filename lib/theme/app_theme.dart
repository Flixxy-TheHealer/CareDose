import 'package:flutter/material.dart';
class AppColors {
  static const primary = Color(0xFF1A56DB);
  static const primaryLight = Color(0xFFEBF2FF);
  static const danger = Color(0xFFE02424);
  static const dangerLight = Color(0xFFFFF5F5);
  static const dangerBorder = Color(0xFFFCA5A5);
  static const warning = Color(0xFFD97706);
  static const warningLight = Color(0xFFFEF3C7);
  static const success = Color(0xFF057A55);
  static const successLight = Color(0xFFDEF7EC);
  static const successGreen = Color(0xFF10B981);
  static const skipped = Color(0xFF9CA3AF);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const background = Color(0xFFF9FAFB);
  static const white = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFFFFFFF);
  static const orange = Color(0xFFD97706);
}
class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}