import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget CategoriesCard({
  required String iconPath,
  required String title,
  double width = 100,
}) {
  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  return Column(
    children: [
      Container(
        width: width,
        height: 68,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
          ),
        ),
      ),

      // <-- Badge
      const SizedBox(height: 8),
      Flexible(child: Text(title, style: _archivoTextStyle())),
    ],
  );
}
