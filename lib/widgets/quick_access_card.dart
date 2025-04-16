import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickAccessCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width:100,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,                   // same light grey background
          borderRadius: BorderRadius.circular(12),       // rounded corners
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18.0),        // equal padding around
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 28,
                  width: 28,                             // fixed icon size
                  child: icon,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.archivo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,         // slightly bolder
                    // your primary text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
