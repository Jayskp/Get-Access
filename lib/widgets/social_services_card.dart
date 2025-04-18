import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;
  final double borderRadius;

  const ServiceCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle archivoTextStyle({
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

    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top image with rounded top corners
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 8),

              // Responsive title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: archivoTextStyle(
                      fontSize: 16, // this is the max size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
