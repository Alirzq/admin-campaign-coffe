import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/order_controller.dart';
import '../../../../global-component/custom_navbar.dart';
import '../../../../global-component/order_card.dart';

class FullOrderListPage extends GetView<OrderController> {
  const FullOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // warna putih
            size: 28, // agak besar/tebal
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: controller.orderList.length,
          itemBuilder: (context, index) {
            final order = controller.orderList[index];
            return OrderCard(
              orderName: order['orderName']!,
              orderItems: order['orderItems']!,
              price: order['price']!,
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
