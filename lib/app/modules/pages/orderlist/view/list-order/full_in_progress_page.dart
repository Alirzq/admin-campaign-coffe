import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/order_controller.dart';
import '../../../../../global-component/order/order_card.dart';
import '../detail-order/order_detail_page_in-progress.dart';
import '../../../../../../utils/currency_formatter.dart';

class FullInProgressPage extends GetView<OrderController> {
  const FullInProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'In-Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.inProgressList.isEmpty) {
            return Center(child: Text('Belum ada order in-progress.'));
          }
          return ListView.builder(
            itemCount: controller.inProgressList.length,
            itemBuilder: (context, index) {
              final order = controller.inProgressList[index];
              return OrderCard(
                orderName: order.customerName,
                orderItems: order.items.map((e) => e.productName).join(', '),
                price: CurrencyFormatter.formatCurrencyFromDouble(
                    order.totalPrice),
                onTap: () {
                  Get.to(() => const OrderInProgressDetailPage(), arguments: {
                    // Primary fields - sesuai dengan JSON structure
                    'id': order.id,
                    'customer_name': order.customerName,
                    'total_price': order.totalPrice.toInt(),
                    'order_type': order.orderType,
                    'created_at':
                        order.getFormattedDate(), // Format: dd-MM-yyyy HH:mm
                    'payment_method': order.paymentMethod,
                    'location': order.location,
                    'notes': order.notes,
                    'status': order.status,

                    // Items dengan structure yang benar
                    'items': order.items
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

                    // Alternative field names untuk backward compatibility
                    'orderId': order.id,
                    'orderName': order.customerName,
                    'price': order.totalPrice.toInt(),
                    'paymentMethod': order.paymentMethod,
                    'orderType': order.orderType,
                    'orderItems': order.items
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
                  });
                },
              );
            },
          );
        }),
      ),
    );
  }
}
