import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int index) onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> categoryIcons = {
      "Coffee": 'assets/coffee.svg',
      "Non Coffee": 'assets/non_coffee.svg',
      "Snack": 'assets/snack.svg',
      "Main Course": 'assets/main_course.svg',
      "Noodles": 'assets/noodles.svg',
    };

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 20), // jarak antar item
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final categoryName = categories[index];
          final iconPath = categoryIcons[categoryName] ?? '';

          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.blue.shade900 : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  categoryName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue.shade900 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
