import 'package:admin_campaign_coffe_repo/app/global-component/order/order_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/order_controller.dart';
import 'list-order/full_order_list_page.dart';
import 'list-order/full_in_progress_page.dart';
import 'list-order/full_deliver_page.dart';
import 'package:admin_campaign_coffe_repo/app/global-component/order/order_card.dart';
import 'detail-order/order_detail_page_order-list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find<OrderController>();
    // Pastikan data selalu fresh saat halaman dibuka
    controller.fetchAllOrders();

    Map<String, String> orderToMap(order) {
      return {
        'orderName': order.customerName,
        'orderItems': order.items.isNotEmpty ? order.items.map((e) => e.productName).join(', ') : '-',
        'price': 'Rp. ${order.totalPrice.toInt()}',
      };
    }

    List<String> getOrderItems(order) {
      return order.items.isNotEmpty ? order.items.map((e) => e.productName).toList() : [];
    }

    return Expanded(
      child: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              OrderSectionCard(
                title: "Deliver List",
                data: controller.orderList.isNotEmpty ? orderToMap(controller.orderList[0]) : {},
                onTap: () => Get.to(() => const FullOrderListPage()),
              ),
              OrderSectionCard(
                title: "In-Progress",
                data: controller.inProgressList.isNotEmpty ? orderToMap(controller.inProgressList[0]) : {},
                onTap: () => Get.to(() => const FullInProgressPage()),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
