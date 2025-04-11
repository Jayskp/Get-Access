import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildCategoryCard({
  required String iconPath,
  required String title,
  required String subtitle,
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
        height: 63,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
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
      SizedBox(height: 8),
      Text(title, style: _archivoTextStyle()),
      Text(
        subtitle,
        style: _archivoTextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}
