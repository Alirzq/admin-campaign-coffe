import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/order_controller.dart';
import '../../../../global-component/widget/custom_navbar.dart';
import '../../../../global-component/order/header_order_view.dart';
import '../../../../global-component/order/order_section_card.dart';

import 'full_order_list_page.dart';
import 'full_in_progress_page.dart';
import 'full_deliver_page.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          const HeaderAdmin(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    OrderSectionCard(
                      title: "Order List",
                      data: controller.orderList[0],
                      onTap: () => Get.to(() => const FullOrderListPage()),
                    ),
                    OrderSectionCard(
                      title: "In-Progress",
                      data: controller.inProgressList[0],
                      onTap: () => Get.to(() => const FullInProgressPage()),
                    ),
                    OrderSectionCard(
                      title: "Deliver",
                      data: controller.deliverList[0],
                      onTap: () => Get.to(() => const FullDeliverPage()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
