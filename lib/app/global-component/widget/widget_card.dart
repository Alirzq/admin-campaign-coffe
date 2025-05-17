import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const WidgetCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 60,
              width: 60,
              color: const Color(0xFF014AAD),
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF014AAD),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
