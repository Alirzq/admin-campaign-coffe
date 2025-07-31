import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';

class OrderInProgressDetailPage extends StatelessWidget {
  const OrderInProgressDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String customerName = args['orderName'] ?? '-';
    final List items = (args['orderItems'] as List?) ?? [];
    final int totalPrice = args['price'] is int ? args['price'] : int.tryParse(args['price']?.toString() ?? '') ?? 0;
    final int? orderId = args['orderId'] as int?;
    final String paymentMethod = args['paymentMethod'] ?? '-';
    final String location = args['location'] ?? '-';
    final String status = args['status'] ?? 'inprogress';

    final OrderController controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail Orders',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                ),
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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF0D47A1)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        customerName,
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
                    ...items.map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['quantity']} x ${item['productName'] ?? item['name'] ?? '-'}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            Text('Rp. ${(item['price'] * (item['quantity'] ?? 1)).toInt()}',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ],
                        )),
                    const Divider(height: 24),
                    _infoRow("Total Order :", "${items.length} items"),
                    _infoRow("Total Price :", "Rp. $totalPrice"),
                    _infoRow("Payment Method:", paymentMethod),
                    _infoRow("Location:", location),
                  ],
                ),
                const SizedBox(height: 20),
                if (controller != null && orderId != null && status == 'inprogress')
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.markDone(orderId!);
                        await controller.fetchAllOrders();
                        Get.snackbar('Sukses', 'Order selesai (completed)');
                        // Tidak perlu Get.back() agar tetap di halaman detail
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 164, 159, 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Selesaikan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else if (status == 'completed')
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Selesai',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}