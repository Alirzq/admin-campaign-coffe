import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/controller/pickup_controller.dart';
import 'package:admin_campaign_coffe_repo/app/global-component/order/pickup_order_card.dart';
import '../detail-pickup/pickup_detail_in_progress_page.dart';
import '../../../../../../utils/currency_formatter.dart';

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
        child: Obx(() {
          if (controller.inProgressList.isEmpty) {
            return const Center(child: Text('Belum ada pickup.'));
          }
          return ListView.builder(
            itemCount: controller.inProgressList.length,
            itemBuilder: (context, index) {
              final pickup = controller.inProgressList[index];
              return PickupOrderCard(
                pickupName: pickup.customerName,
                pickupItems: pickup.items.map((e) => e.productName).join(', '),
                price: CurrencyFormatter.formatCurrencyFromDouble(
                    pickup.totalPrice),
                items: pickup.items.map((e) => e.productName).toList(),
                onTap: () => Get.to(() => const PickupInProgressDetailPage(),
                    arguments: {
                      // Primary fields
                      'id': pickup.id,
                      'customer_name': pickup.customerName,
                      'total_price': pickup.totalPrice.toInt(),
                      'order_type': pickup.orderType,
                      'created_at': pickup.getFormattedDate(),
                      'payment_method': pickup.paymentMethod,
                      'location': pickup.location,
                      'notes': pickup.notes,
                      'status': pickup.status,

                      // Detail item structure
                      'items': pickup.items
                          .map((item) => {
                                'id': item.id,
                                'product_id': item.productId,
                                'product_name': item.productName,
                                'product_image': item.productImage,
                                'price': item.price,
                                'quantity': item.quantity,
                                'size': item.size,
                                'sugar': item.sugar,
                                'temperature': item.temperature,
                              })
                          .toList(),

                      // Alternative field names (optional for compatibility)
                      'orderId': pickup.id,
                      'orderName': pickup.customerName,
                      'price': pickup.totalPrice.toInt(),
                      'paymentMethod': pickup.paymentMethod,
                      'orderType': pickup.orderType,
                      'orderItems': pickup.items
                          .map((item) => {
                                'name': item.productName,
                                'productName': item.productName,
                                'price': item.price,
                                'quantity': item.quantity,
                                'size': item.size,
                                'sugar': item.sugar,
                                'temperature': item.temperature,
                              })
                          .toList(),
                    }),
              );
            },
          );
        }),
      ),
    );
  }
}
