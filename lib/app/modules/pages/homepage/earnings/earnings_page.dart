import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../controller/earnings_controller.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../global-component/widget/stat_card.dart';
import '../../../../../utils/currency_formatter.dart';

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
    final isTablet = MediaQuery.of(context).size.width > 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Sales Section
              Center(
                child: Column(
                  children: [
                    Text(
                      "Total Sales",
                      style: GoogleFonts.poppins(
                          fontSize: isTablet ? 32.0 : 24.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/monthly-earnings');
                        },
                        child: Text(
                          CurrencyFormatter.formatCurrencyFromDouble(
                              controller.monthlySales.value.totalSales),
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 48.0 : 34.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade900,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }),
                    Text(
                      "Month: ${controller.monthlySales.value.monthYear}",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 24.0 : 16.0),

              // Stats Cards Section
              if (isTablet) ...[
                // Tablet Layout - 3 cards horizontal
                Obx(() {
                  final completedOrders = controller.earnings
                      .where((order) => order.status == 'completed')
                      .toList();
                  final pendingOrders = controller.earnings
                      .where((order) => order.status == 'paid')
                      .toList();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Today's Date",
                          value: getCurrentDayDate(),
                          titleColor: const Color.fromARGB(255, 134, 134, 134),
                          valueColor: const Color.fromARGB(255, 98, 98, 98),
                          titleFontWeight: FontWeight.w700,
                          valueFontWeight: FontWeight.w800,
                          valueFontSize: isTablet ? 24.0 : 19.0,
                          valueAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Expanded(
                        child: StatCard(
                          title: "Total Order",
                          value: completedOrders.length.toString(),
                          titleColor: const Color.fromARGB(255, 134, 134, 134),
                          valueColor: const Color.fromARGB(255, 98, 98, 98),
                          titleFontWeight: FontWeight.w700,
                          valueFontWeight: FontWeight.w800,
                          valueFontSize: isTablet ? 24.0 : 19.0,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Expanded(
                        child: StatCard(
                          title: "Pending Orders",
                          value: pendingOrders.length.toString(),
                          titleColor: const Color.fromARGB(255, 134, 134, 134),
                          valueColor: const Color.fromARGB(255, 98, 98, 98),
                          titleFontWeight: FontWeight.w700,
                          valueFontWeight: FontWeight.w800,
                          valueFontSize: isTablet ? 24.0 : 19.0,
                        ),
                      ),
                    ],
                  );
                }),
              ] else ...[
                // Mobile Layout - 2 cards horizontal
                Obx(() {
                  final completedOrders = controller.earnings
                      .where((order) => order.status == 'completed')
                      .toList();

                  return Row(
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
                      SizedBox(width: 20),
                      StatCard(
                        title: "Total Order",
                        value: completedOrders.length.toString(),
                        titleColor: const Color.fromARGB(255, 134, 134, 134),
                        valueColor: const Color.fromARGB(255, 98, 98, 98),
                        titleFontWeight: FontWeight.w700,
                        valueFontWeight: FontWeight.w800,
                      ),
                    ],
                  );
                }),
              ],

              SizedBox(height: isTablet ? 40.0 : 30.0),

              // New Order Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(isTablet ? 16.0 : 10.0),
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
                              fontSize: isTablet ? 24.0 : 18.0,
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
                              fontSize: isTablet ? 18.0 : 14.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16.0 : 10.0),

                    // Orders List
                    Obx(() {
                      final paidOrders = controller.earnings
                          .where((order) => order.status == 'paid')
                          .toList();

                      if (paidOrders.isEmpty) {
                        return Container(
                          height: isTablet ? 200.0 : 260.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: isTablet ? 64.0 : 48.0,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Belum ada order baru',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 18.0 : 16.0,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Container(
                        height: isTablet
                            ? (MediaQuery.of(context).size.height * 0.7) / 2
                            : 260.0,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: paidOrders.length,
                          itemBuilder: (context, index) {
                            final order = paidOrders[index];
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: isTablet ? 12.0 : 8.0),
                              child: OrderCard(
                                orderName: order.customerName,
                                orderItems: order.items
                                    .map((item) => item.productName)
                                    .join(', '),
                                price:
                                    CurrencyFormatter.formatCurrencyFromDouble(
                                        order.totalPrice),
                              ),
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
      },
    );
  }
}
