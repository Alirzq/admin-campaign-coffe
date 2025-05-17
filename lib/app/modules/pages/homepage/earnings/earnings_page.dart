import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/earnings_controller.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../global-component/widget/stat_card.dart';

class EarningsPage extends StatelessWidget {
  EarningsPage({super.key});
  final EarningsController controller = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: Colors.blue.shade900,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Store is Open",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                Obx(() => Switch(
                      value: controller.isStoreOpen.value,
                      onChanged: (bool value) {
                        controller.toggleStore(value);
                      },
                      activeColor: Colors.blue.shade900,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 35),
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
                Text(
                  "Rp 500.000",
                  style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                title: "Avg Per Month",
                value: "Rp 500.000",
                titleColor: const Color.fromARGB(255, 98, 98, 98),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w600,
                valueFontWeight: FontWeight.w800,
              ),
              SizedBox(
                width: 20,
              ),
              StatCard(
                title: "Formings Growth",
                value: "12%",
                titleColor: const Color.fromARGB(255, 98, 98, 98),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w600,
                valueFontWeight: FontWeight.w800,
              ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() => SizedBox(
                      height: 260,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: controller.newOrders.length,
                        itemBuilder: (context, index) {
                          final order = controller.newOrders[index];
                          return OrderCard(
                            orderName: order['orderName']!,
                            orderItems: order['orderItems']!,
                            price: order['price']!,
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
