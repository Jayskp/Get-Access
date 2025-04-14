import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget propertyCard({
  required String imageUrl,
  required String title,
  required String location,
  required String price,
  required String bhk,
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
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.asset(
            imageUrl,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: _archivoTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    )
                  ),
                  Spacer(),
                  Text(
                    bhk,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    )
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    location,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      color: Colors.grey
                    )
                  ),
                  Spacer(),
                  Text(
                    price,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      color: Colors.grey
                    )
                  ),

                ],
              ),
              SizedBox(height:10),

            ],
          ),
        ),
      ],
    ),
  );
}
