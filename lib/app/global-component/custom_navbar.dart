import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GNav(
          selectedIndex: currentIndex,
          onTabChange: onTap,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[200]!,
          haptic: true,
          tabBorderRadius: 12,
          tabActiveBorder: Border.all(
              color: Colors.blue.shade900, width: 2),
          tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
          tabShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ],
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 400),
          gap: 6,
          color: Colors.grey[800],
          activeColor: Colors.blue.shade900,
          iconSize: 24,
          tabBackgroundColor: Colors.blue.shade100.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
              horizontal: 27, vertical: 10),
          tabs: [
            _buildNavItem("assets/home-icon.svg", "Home"),
            _buildNavItem("assets/box-icon.svg", "Stock"),
            _buildNavItem("assets/document-icon.svg", "Order"),
            _buildNavItem("assets/widgets-icon.svg", "Widgets"),
          ],
        ),
      ),
    );
  }

  GButton _buildNavItem(String assetPath, String label) {
    return GButton(
      text: label,
      icon: Icons.circle,
      leading: SizedBox(
        width: 22,
        height: 22,
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }
}
