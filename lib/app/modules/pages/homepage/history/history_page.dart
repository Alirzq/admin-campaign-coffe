import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../../controller/history_controller.dart';
import '../../orderlist/view/detail-order/order_detail_page_order-list.dart';
import '../../orderlist/view/detail-pickup/pickup_detail_page.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final HistoryController historyController = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: historyController.orderHistory.length,
          itemBuilder: (context, index) {
            final order = historyController.orderHistory[index];
            return OrderCard(
              orderName: order.customerName,
              orderItems: order.items.join(', '),
              price: 'Rp. ${order.totalPrice.toInt()}',
              onTap: () {
                if (order.customerName.toLowerCase().contains('pesanan')) {
                  Get.to(() => const OrderDetailPage(), arguments: {
                    'orderName': order.customerName,
                    'orderItems': order.items.join(', '),
                    'price': order.totalPrice.toInt(),
                  });
                } else if (order.customerName.toLowerCase().contains('pickup')) {
                  Get.to(() => const PickupDetailPage(), arguments: {
                    'pickupName': order.customerName,
                    'pickupItems': order.items.join(', '),
                    'price': order.totalPrice.toInt(),
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
