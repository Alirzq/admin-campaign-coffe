import 'package:admin_campaign_coffe_repo/app/modules/pages/homepage/detail-history/detail_order_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../../controller/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  // Function to format date to Indonesian format
  String formatDateToIndonesian(DateTime date) {
    List<String> dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    List<String> monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    String dayName = dayNames[date.weekday - 1];
    String monthName = monthNames[date.month - 1];

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Obx(() {
        if (historyController.orderHistory.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat pesanan'),
          );
        }

        // Group orders by date
        Map<String, List<dynamic>> groupedOrders = {};
        for (var order in historyController.orderHistory) {
          String dateKey = '';
          try {
            if (order.createdAt != null && order.createdAt!.isNotEmpty) {
              DateTime parsedDate = DateTime.parse(order.createdAt!);
              dateKey = DateFormat('yyyy-MM-dd').format(parsedDate);
            } else {
              dateKey = 'Unknown';
            }
          } catch (e) {
            dateKey = 'Unknown';
          }
          groupedOrders.putIfAbsent(dateKey, () => []).add(order);
        }

        // Sort descending
        List<String> sortedDates = groupedOrders.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedDates.length,
          itemBuilder: (context, dateIndex) {
            String dateKey = sortedDates[dateIndex];
            List<dynamic> ordersForDate = groupedOrders[dateKey]!;

            // Format date for display using local Indonesian format
            String displayDate;
            try {
              if (dateKey != 'Unknown') {
                DateTime date = DateTime.parse(dateKey);
                displayDate = formatDateToIndonesian(date);
              } else {
                displayDate = 'Tanggal Tidak Diketahui';
              }
            } catch (e) {
              displayDate = 'Tanggal Tidak Diketahui';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header tanggal
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayDate,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                // List order untuk tanggal tersebut
                ...ordersForDate.map((order) => OrderCard(
                      orderName: order.customerName,
                      orderItems: order.orderItems
                          .map((item) => item.productName ?? '')
                          .join(', '),
                      price: 'Rp. ${order.totalPrice.toInt()}',
                      onTap: () {
                        // Navigasi ke detail_order_history.dart untuk semua jenis order
                        Get.to(() => const DetailOrderHistory(), arguments: {
                          'id': order.id,
                          'customer_name': order.customerName,
                          'total_price': order.totalPrice.toInt(),
                          'order_type': order.orderType,
                          'created_at': order.createdAt,
                          'payment_method': order.paymentMethod,
                          'location': order.location ?? '-',
                          'notes': order.notes,
                          'status': order.status,
                          'items': order.orderItems
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
                          // Data tambahan untuk kompatibilitas
                          'orderId': order.id,
                          'orderName': order.customerName,
                          'price': order.totalPrice.toInt(),
                          'paymentMethod': order.paymentMethod,
                          'orderType': order.orderType,
                          'orderItems': order.orderItems
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
                    )),
              ],
            );
          },
        );
      }),
    );
  }
}
