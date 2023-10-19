import 'package:flutter/material.dart';
import '../Constants/app_colors.dart';

SnackBar appSnackBar({required String text}) => SnackBar(
      backgroundColor: AppColors.grey,
      content: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
