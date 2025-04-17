import 'package:admin_campaign_coffe_repo/app/modules/pages/orderlist/view/order_view.dart';
import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/earnings_controller.dart';
import '../../../../global-component/order_card.dart';
import '../../../../global-component/stat_card.dart';

class EarningsPage extends StatelessWidget {
  EarningsPage({super.key});
  final EarningsController controller = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Store Switch
          Center(
            child: Obx(() => Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store,
                              color: Colors.blue.shade900, size: 30),
                          const SizedBox(width: 10),
                          Text(
                            "Store is ${controller.isStoreOpen.value ? "Open" : "Closed"}",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: controller.isStoreOpen.value,
                        onChanged: controller.toggleStore,
                        activeColor: Colors.blue.shade900,
                      ),
                    ],
                  ),
                )),
          ),

          const SizedBox(height: 20),

          // ✅ Total Sales
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
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Stats Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                title: "Avg Per Week",
                value: "Rp 500.000",
                titleColor: const Color.fromARGB(255, 98, 98, 98),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w600,
                valueFontWeight: FontWeight.w800,
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

          const SizedBox(height: 16),

          // ✅ New Orders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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

                        Get.to(() => const OrderView());
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

                // List Order dari Controller
                Obx(() => SizedBox(
                      height: 200,
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
