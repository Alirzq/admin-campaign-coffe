import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../../controller/history_controller.dart';
import '../../orderlist/view/detail-order/order_detail_page_order-list.dart';
import '../../orderlist/view/detail-pickup/pickup_detail_page.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Obx(
        () {
          if (historyController.orderHistory.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat pesanan'),
            );
          }

          // Group orders by date (ambil dari order.createdAt)
          Map<String, List<dynamic>> groupedOrders = {};
          for (var order in historyController.orderHistory) {
            String dateKey = '';
            try {
              if (order.createdAt != null && order.createdAt!.isNotEmpty) {
                DateTime orderDate = DateTime.parse(order.createdAt!);
                dateKey = DateFormat('yyyy-MM-dd').format(orderDate);
              } else {
                dateKey = 'Unknown';
              }
            } catch (e) {
              dateKey = 'Unknown';
            }
            groupedOrders.putIfAbsent(dateKey, () => []).add(order);
          }

          // Sort dates descending (newest first)
          List<String> sortedDates = groupedOrders.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedDates.length,
            itemBuilder: (context, dateIndex) {
              String dateKey = sortedDates[dateIndex];
              List<dynamic> ordersForDate = groupedOrders[dateKey]!;

              // Format tanggal untuk display
              String displayDate;
              try {
                if (dateKey != 'Unknown') {
                  DateTime date = DateTime.parse(dateKey);
                  displayDate =
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
                } else {
                  displayDate = 'Tanggal Tidak Diketahui';
                }
              } catch (e) {
                displayDate = 'Tanggal Tidak Diketahui';
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header tanggal di tengah
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
                  // List orders untuk tanggal tersebut
                  ...ordersForDate.map((order) => OrderCard(
                        orderName: order.customerName,
                        orderItems: order.orderItems
                            .map((item) => item.productName ?? '')
                            .join(', '),
                        price: 'Rp. ${order.totalPrice.toInt()}',
                        onTap: () {
                          // Kirim data lengkap ke detail
                          if ((order.orderType ?? '')
                              .toLowerCase()
                              .contains('pickup')) {
                            Get.to(() => const PickupDetailPage(), arguments: {
                              'pickupName': order.customerName,
                              'pickupItems': order.orderItems
                                  .map((item) => item.productName ?? '')
                                  .join(', '),
                              'price': order.totalPrice.toInt(),
                              'orderId': order.id,
                              'orderType': order.orderType,
                              'createdAt': order.createdAt,
                              'paymentMethod': order.paymentMethod,
                              'location': order.address ?? '-',
                              'status': order.status,
                              'notes': order.notes,
                              'orderItems': order.orderItems
                                  .map((item) => {
                                        'product_name': item.productName,
                                        'product_image': item.productImage,
                                        'price': item.price,
                                        'quantity': item.quantity,
                                        'sugar': item.sugar,
                                        'temperature': item.temperature,
                                        'size': item.size,
                                      })
                                  .toList(),
                            });
                          } else {
                            Get.to(() => const OrderDetailPage(), arguments: {
                              // Primary fields - sesuai dengan JSON structure
                              'id': order.id,
                              'customer_name': order.customerName,
                              'total_price': order.totalPrice.toInt(),
                              'order_type': order.orderType,
                              'created_at': order.createdAt,
                              'payment_method': order.paymentMethod,
                              'location': order.address ?? '-',
                              'notes': order.notes,
                              'status': order.status,

                              // Items dengan structure yang benar
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

                              // Alternative field names untuk backward compatibility
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
                          }
                        },
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
