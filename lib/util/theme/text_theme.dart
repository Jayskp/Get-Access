import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    titleLarge: TextStyle().copyWith(
      fontSize: 18,
      fontVariations: [FontVariation('wght', 700)],
      color: Colors.black,
    ),
    titleMedium: TextStyle().copyWith(fontSize: 16, color: AppColors.textGrey),
    displayLarge: TextStyle().copyWith(
      fontSize: 16,
      fontVariations: [FontVariation('wght', 600)],
      fontFamily: 'Roboto',
    ),
    displayMedium: TextStyle().copyWith(
      fontSize: 14,
      fontVariations: [FontVariation('wght', 700)],
      fontFamily: 'Roboto',
    ),
    displaySmall: TextStyle().copyWith(fontSize: 12, fontFamily: 'Roboto'),
  );
}
