import 'package:admin_campaign_coffe_repo/app/global-component/order/pickup_order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail-pickup/pickup_detail_in_progress_page.dart';
import 'package:admin_campaign_coffe_repo/controller/pickup_controller.dart';

class FullPickupInProgressPage extends StatelessWidget {
  const FullPickupInProgressPage({super.key});

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
          "In-Progress Pickup",
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
          itemCount: controller.inProgressPickupList.length,
          itemBuilder: (context, index) {
            final pickup = controller.inProgressPickupList[index];
            return PickupOrderCard(
              pickupName: pickup['pickupName']!,
              pickupItems: pickup['pickupItems']!,
              price: pickup['price']!,
              onTap: () => Get.to(() => PickupInProgressDetailPage(
                    pickupName: pickup['pickupName']!,
                    pickupItems: pickup['pickupItems']!,
                    price: pickup['price']!,
                  )),
            );
          },
        ),
      ),
    );
  }
}
