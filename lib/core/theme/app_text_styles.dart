import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}