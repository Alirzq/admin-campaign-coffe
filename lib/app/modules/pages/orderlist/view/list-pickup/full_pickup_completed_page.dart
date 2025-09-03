import 'package:admin_campaign_coffe_repo/app/global-component/order/pickup_order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/controller/pickup_controller.dart';
import '../detail-pickup/pickup_detail_completed_page.dart';
import '../../../../../../utils/currency_formatter.dart';

class FullPickupCompletedPage extends StatelessWidget {
  const FullPickupCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PickupController controller = Get.find<PickupController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Completed Pickup",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: controller.deliverList.length,
          itemBuilder: (context, index) {
            final pickup = controller.deliverList[index];
            return PickupOrderCard(
              pickupName: pickup.customerName,
              pickupItems: pickup.items.map((e) => e.productName).join(', '),
              price:
                  CurrencyFormatter.formatCurrencyFromDouble(pickup.totalPrice),
              items: pickup.items.map((e) => e.productName).toList(),
              onTap: () =>
                  Get.to(() => const PickupDetailCompletedPage(), arguments: {
                'orderId': pickup.id,
                'orderName': pickup.customerName,
                'orderItems': pickup.items.map((e) => e.productName).toList(),
                'price': pickup.totalPrice.toInt(),
                'paymentMethod': pickup.paymentMethod,
                'location': pickup.location,
              }),
            );
          },
        ),
      ),
    );
  }
}
