import 'package:admin_campaign_coffe_repo/app/modules/pages/homepage/detail-history/detail_order_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../global-component/order/order_card.dart';
import '../../../../global-component/widget/date_picker_widget.dart';
import '../../../../../controller/history_controller.dart';
import '../../../../../utils/currency_formatter.dart';

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

  // Function to format date for display
  String formatDateForDisplay(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          // Header dengan Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Date Picker Section
                Obx(() => DatePickerWidget(
                      selectedDate: historyController.selectedDate.value,
                      onDateSelected: (date) =>
                          historyController.selectDate(date),
                      label: "Pilih Tanggal",
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    )),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Obx(() {
              if (historyController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                  ),
                );
              }

              // Calculate total orders and revenue
              final totalOrders = historyController.filteredHistory.length;
              final totalRevenue = historyController.filteredHistory
                  .fold<double>(0, (sum, order) => sum + order.totalPrice);

              return Column(
                children: [
                  // Summary Cards - Simple Design
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Total Orders',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  totalOrders.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Total Revenue',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  CurrencyFormatter.formatCurrencyFromDouble(
                                      totalRevenue),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Orders List or Empty State
                  Expanded(
                    child: historyController.filteredHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada riwayat pesanan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'untuk tanggal ${formatDateForDisplay(historyController.selectedDate.value)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: historyController.filteredHistory.length,
                            itemBuilder: (context, index) {
                              final order =
                                  historyController.filteredHistory[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: OrderCard(
                                  orderName: order.customerName,
                                  orderItems: order.orderItems
                                      .map((item) => item.productName ?? '')
                                      .join(', '),
                                  price: CurrencyFormatter
                                      .formatCurrencyFromDouble(
                                          order.totalPrice),
                                  onTap: () {
                                    // Navigasi ke detail_order_history.dart untuk semua jenis order
                                    Get.to(() => const DetailOrderHistory(),
                                        arguments: {
                                          'id': order.id,
                                          'customer_name': order.customerName,
                                          'total_price':
                                              order.totalPrice.toInt(),
                                          'order_type': order.orderType,
                                          'created_at': order.createdAt,
                                          'payment_method': order.paymentMethod,
                                          'location': order.location,
                                          'notes': order.notes,
                                          'status': order.status,
                                          'items': order.orderItems
                                              .map((item) => {
                                                    'id': item.id,
                                                    'product_id':
                                                        item.productId,
                                                    'product_name':
                                                        item.productName,
                                                    'product_image':
                                                        item.productImage,
                                                    'price': item.price,
                                                    'quantity': item.quantity,
                                                    'size': item.size,
                                                    'sugar': item.sugar,
                                                    'temperature':
                                                        item.temperature,
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
                                                    'productName':
                                                        item.productName,
                                                    'price': item.price,
                                                    'quantity': item.quantity,
                                                    'size': item.size,
                                                    'sugar': item.sugar,
                                                    'temperature':
                                                        item.temperature,
                                                  })
                                              .toList(),
                                        });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
