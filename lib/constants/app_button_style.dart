import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppButtonStyle {
  static final ButtonStyle elevated = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    textStyle: AppTextStyle.buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static final ButtonStyle elevatedDanger = ElevatedButton.styleFrom(
    backgroundColor: AppColors.expense,
    foregroundColor: AppColors.white,
    textStyle: AppTextStyle.buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static final ButtonStyle outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary, width: 1.5),
    textStyle: AppTextStyle.buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static final ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyle.buttonText,
  );
}
