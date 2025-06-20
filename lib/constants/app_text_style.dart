import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyle {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'main',
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'main',
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'main',
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontFamily: 'main',
  );

  static const TextStyle balancePositive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.income,
    fontFamily: 'main',
  );

  static const TextStyle balanceNegative = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.expense,
    fontFamily: 'main',
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    fontFamily: 'main',
  );

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'main',
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontFamily: 'main',
  );
}
