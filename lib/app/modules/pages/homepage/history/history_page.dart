import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../../controller/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final HistoryController historyController = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: historyController.orderHistory.length,
          itemBuilder: (context, index) {
            final order = historyController.orderHistory[index];
            return OrderCard(
              orderName: order['orderName']!,
              orderItems: order['orderItems']!,
              price: order['price']!,
              onTap: () {
                // Tambahkan aksi ketika card di tap
              },
            );
          },
        ),
      ),
    );
  }
}
