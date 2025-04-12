import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final FontWeight titleFontWeight;
  final FontWeight valueFontWeight;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    this.titleColor = Colors.black,
    this.valueColor = Colors.black,
    this.titleFontWeight = FontWeight.w500,
    this.valueFontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade700.withOpacity(0.20),
              blurRadius: 7,
              offset: const Offset(0, 3), // shadow ke bawah
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: titleFontWeight,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: valueFontWeight,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
