import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  final List<_NavItem> navItems = const [
    _NavItem(
        index: 0,
        label: "Home",
        iconPath: "assets/home-icon.svg",
        route: "/home"),
    _NavItem(
        index: 1,
        label: "Stock",
        iconPath: "assets/box-icon.svg",
        route: "/stock"),
    _NavItem(
        index: 2,
        label: "Order",
        iconPath: "assets/document-icon.svg",
        route: "/order"),
    _NavItem(
        index: 3,
        label: "Widgets",
        iconPath: "assets/widgets-icon.svg",
        route: "/widget"),
  ];

  @override
  Widget build(BuildContext context) {
    String currentRoute = Get.currentRoute;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isSelected = currentRoute == item.route;
          final iconColor = isSelected ? Colors.blue.shade900 : Colors.grey;
          final textStyle = TextStyle(
            color: iconColor,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          );

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                Get.offNamed(item.route);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.iconPath,
                  width: 27,
                  height: 27,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(height: 4),
                Text(item.label, style: textStyle),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final int index;
  final String label;
  final String iconPath;
  final String route;

  const _NavItem({
    required this.index,
    required this.label,
    required this.iconPath,
    required this.route,
  });
}
