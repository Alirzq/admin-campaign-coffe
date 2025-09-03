import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import '../../../../../../utils/currency_formatter.dart';

class OrderDetailDeliverPage extends StatelessWidget {
  final int orderId;
  final String orderName;
  final List<Map<String, dynamic>> orderItems;
  final double totalPrice;
  final String paymentMethod;
  final String location;
  final String status;

  const OrderDetailDeliverPage({
    super.key,
    required this.orderId,
    required this.orderName,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentMethod,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detail Orders",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            AssetImage('assets/images/user_dummy.jpg'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        orderName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order List',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...orderItems.map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['quantity']} x ${item['name'] ?? '-'}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            Text(
                                CurrencyFormatter.formatCurrency(
                                    (item['price'] * (item['quantity'] ?? 1))
                                        .toInt()),
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ],
                        )),
                    const Divider(height: 24),
                    infoRow("Total Order :", "${orderItems.length} items"),
                    infoRow("Total Price :",
                        CurrencyFormatter.formatCurrencyFromDouble(totalPrice)),
                    infoRow("Payment Method:", paymentMethod),
                    infoRow("Location:", location),
                  ],
                ),
                const SizedBox(height: 16),
                if (status == 'delivered' || status == 'completed')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Delivered',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Panggil controller untuk update status ke delivered
                        final orderController = Get.find<OrderController>();
                        await orderController.markDone(orderId);
                        Get.snackbar(
                            'Sukses', 'Order berhasil di-mark delivered');
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 25, 164, 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Deliver',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
