import 'package:admin_campaign_coffe_repo/app/global-component/widget/header_custom_widgets.dart';
import 'package:admin_campaign_coffe_repo/app/global-component/widget/custom_navbar.dart';
import 'package:admin_campaign_coffe_repo/app/global-component/widget/widget_card.dart';
import 'package:admin_campaign_coffe_repo/controller/custom_widgets_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWidgetView extends GetView<CustomWidgetController> {
  const CustomWidgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          const HeaderCustomWidgets(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                WidgetCard(
                  title: 'Banner Promotion',
                  iconPath: 'assets/banner_icon.svg',
                  onTap: controller.goToBanner,
                ),
                const SizedBox(height: 30),
                WidgetCard(
                  title: 'Menu',
                  iconPath: 'assets/menu_food_icon.svg',
                  onTap: controller.goToAddMenuWidget,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
