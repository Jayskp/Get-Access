import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialServiceCardMarketplace extends StatelessWidget {
  final String image;
  final String title;
  final String label; // <-- new
  final VoidCallback? onTap;
  final double borderRadius;

  const SocialServiceCardMarketplace({
    super.key,
    required this.image,
    required this.title,
    required this.label, // <-- new
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

    // Determine background color based on label text:
    final Color labelBgColor;
    switch (label.toLowerCase()) {
      case 'new':
        labelBgColor = AppColors.primaryGreen;
        break;
      case 'resale':
        labelBgColor = AppColors.primaryYellow;
        break;
      default:
        labelBgColor = Colors.grey.shade400;
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
              // Top image with a positioned label
              Stack(
                children: [
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

                  // Position the label in the top-left corner
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: labelBgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        style: archivoTextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: archivoTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
