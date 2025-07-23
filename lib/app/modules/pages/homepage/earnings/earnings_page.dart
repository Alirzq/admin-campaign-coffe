import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../controller/earnings_controller.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../global-component/widget/stat_card.dart';

class EarningsPage extends StatelessWidget {
  EarningsPage({super.key});
  final EarningsController controller = Get.put(EarningsController());

  String getCurrentDayDate() {
    final now = DateTime.now();
    final day = DateFormat('E').format(now);
    final date = DateFormat('d').format(now);
    final year = DateFormat('y').format(now);
    return '$day,$date,$year';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "Total Sales",
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade900),
                ),
                Obx(() {
                  final completedOrders = controller.earnings
                      .where((order) => order.status == 'completed')
                      .toList();
                  final totalSales = completedOrders.fold<double>(
                      0, (sum, order) => sum + order.totalPrice);
                  return Text(
                    "Rp ${NumberFormat('#,###', 'id_ID').format(totalSales)}",
                    style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade900),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                title: "Today's Date",
                value: getCurrentDayDate(),
                titleColor: const Color.fromARGB(255, 134, 134, 134),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w700,
                valueFontWeight: FontWeight.w800,
                valueFontSize: 19,
                valueAlign: TextAlign.center,
              ),
              SizedBox(
                width: 20,
              ),
              Obx(() {
                // Total Order dari order status 'completed' saja
                final completedOrders = controller.earnings
                    .where((order) => order.status == 'completed')
                    .toList();
                return StatCard(
                  title: "Total Order",
                  value: completedOrders.length.toString(),
                  titleColor: const Color.fromARGB(255, 134, 134, 134),
                  valueColor: const Color.fromARGB(255, 98, 98, 98),
                  titleFontWeight: FontWeight.w700,
                  valueFontWeight: FontWeight.w800,
                );
              }),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Order",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue.shade900),
                    ),
                    TextButton(
                      onPressed: () {
                        if (!Get.isRegistered<OrderController>()) {
                          Get.put(OrderController());
                        }

                        Get.offAllNamed('/order');
                      },
                      child: Text(
                        "View All",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final paidOrders = controller.earnings
                      .where((order) => order.status == 'paid')
                      .toList();
                  if (paidOrders.isEmpty) {
                    return SizedBox(
                      height: 260,
                      child: Center(
                        child: Text('Belum ada order baru.',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemCount: paidOrders.length,
                      itemBuilder: (context, index) {
                        final order = paidOrders[index];
                        return OrderCard(
                          orderName: order.customerName,
                          orderItems: order.items
                              .map((item) => item.productName)
                              .join(', '),
                          price: 'Rp. ${order.totalPrice.toInt()}',
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
