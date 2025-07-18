import 'package:admin_campaign_coffe_repo/controller/pickup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../global-component/order/pickup_order_card.dart';
import '../detail-pickup/pickup_detail_page.dart';

class FullPickupListPage extends StatelessWidget {
  const FullPickupListPage({super.key});

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
          "Pickup List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: controller.orderList.isEmpty
            ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text('Belum ada order pickup.',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.orderList.length,
                itemBuilder: (context, index) {
                  final pickup = controller.orderList[index];
                  return PickupOrderCard(
                    pickupName: pickup.customerName,
                    pickupItems: pickup.items.isNotEmpty ? pickup.items.map((e) => e.productName).join(', ') : '-',
                    price: 'Rp. ${pickup.totalPrice.toInt()}',
                    items: pickup.items.map((e) => e.productName).toList(),
                    onTap: () => Get.to(() => const PickupDetailPage(), arguments: {
                      'orderId': pickup.id,
                      'orderName': pickup.customerName,
                      'orderItems': pickup.items.map((e) => {
                        'name': e.productName,
                        'quantity': e.quantity,
                        'price': e.price,
                      }).toList(),
                      'price': pickup.totalPrice.toInt(),
                      'paymentMethod': pickup.paymentMethod,
                      'location': pickup.location,
                      'status': pickup.status,
                    }),
                  );
                },
              ),
      ),
    );
  }
}
