import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_campaign_coffe_repo/controller/order_controller.dart';
import 'package:admin_campaign_coffe_repo/controller/bluetooth_printer_controller.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/currency_formatter.dart';

class OrderInProgressDetailPage extends StatelessWidget {
  const OrderInProgressDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String customerName =
        args['customer_name'] ?? args['orderName'] ?? '-';
    final List items =
        (args['items'] as List?) ?? (args['orderItems'] as List?) ?? [];
    final int totalPrice = args['total_price'] is int
        ? args['total_price']
        : args['price'] is int
            ? args['price']
            : int.tryParse(args['total_price']?.toString() ??
                    args['price']?.toString() ??
                    '') ??
                0;
    final int? orderId = args['id'] as int? ?? args['orderId'] as int?;
    final String paymentMethod =
        args['payment_method'] ?? args['paymentMethod'] ?? '-';
    final String location = args['location'] ?? '-';
    final String status = args['status'] ?? 'inprogress';
    final String orderType = args['order_type'] ?? args['orderType'] ?? '-';
    final String notes = args['notes'] ?? args['note'] ?? '-';
    final String? created_at = args['created_at'];

    final orderController = Get.find<OrderController>();
    final bluetoothPrinterController = Get.find<BluetoothPrinterController>();

    String _formatDateWithMonthName(DateTime date) {
      const monthNames = [
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
      return '${date.day}-${monthNames[date.month - 1]}-${date.year}';
    }

    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty || dateStr == '-') return '-';
      try {
        DateTime dt;
        if (dateStr.contains(' ') && !dateStr.contains('T')) {
          if (dateStr.split('-')[0].length == 4) {
            dt = DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
          } else {
            dt = DateFormat('dd-MM-yyyy HH:mm').parse(dateStr);
          }
        } else if (dateStr.contains('T')) {
          dt = DateTime.parse(dateStr);
        } else if (dateStr.contains('-')) {
          if (dateStr.split('-')[0].length == 4) {
            dt = DateTime.parse(dateStr + ' 00:00:00');
          } else {
            dt = DateFormat('dd-MM-yyyy').parse(dateStr);
          }
        } else {
          dt = DateTime.parse(dateStr);
        }
        return _formatDateWithMonthName(dt);
      } catch (e) {
        return dateStr.isNotEmpty ? dateStr : '-';
      }
    }

    String getPaymentMethodLabel(String? method) {
      if (method == null || method.isEmpty || method == '-') return '-';
      switch (method.toLowerCase()) {
        case 'qris':
          return 'QRIS';
        case 'gopay':
          return 'GoPay';
        case 'bank_transfer':
          return 'Transfer Bank';
        case 'shopeepay':
          return 'ShopeePay';
        case 'credit_card':
          return 'Kartu Kredit';
        case 'cstore':
          return 'Convenience Store';
        case 'midtrans':
        case '':
          return 'Belum dibayar';
        default:
          return method.capitalizeFirst ?? method;
      }
    }

    String getOrderTypeLabel(String? type) {
      if (type == null || type.isEmpty || type == '-') return '-';
      switch (type.toLowerCase()) {
        case 'delivery':
          return 'Delivery';
        case 'pickup':
          return 'Pickup';
        case 'dine_in':
        case 'dine-in':
          return 'Dine In';
        default:
          return type.capitalizeFirst ?? type;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detail Orders",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
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
                    color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customerName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white)),
                            if (orderType.isNotEmpty && orderType != '-')
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(getOrderTypeLabel(orderType),
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Order List',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow("Order ID", "#ORD${orderId ?? '-'}"),
                      infoRow("Tanggal", formatDate(created_at)),
                      infoRow("Tipe Pesanan", getOrderTypeLabel(orderType)),
                      infoRow("Payment Method",
                          getPaymentMethodLabel(paymentMethod)),
                      infoRow("Lokasi", location),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Items',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black)),
                const SizedBox(height: 8),
                ...items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        if (item['product_image'] != null &&
                            item['product_image'].toString().isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                                item['product_image']
                                        .toString()
                                        .startsWith('http')
                                    ? item['product_image']
                                    : 'https://96057b35e6b9.ngrok-free.app/' +
                                        item['product_image']
                                            .toString()
                                            .replaceFirst(RegExp(r'^/'), ''),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.local_cafe,
                                    color: Colors.grey),
                              );
                            }),
                          )
                        else
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.local_cafe,
                                color: Colors.grey),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  item['product_name'] ??
                                      item['productName'] ??
                                      item['name'] ??
                                      '-',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              if (item['size'] != null &&
                                  item['size'].toString().isNotEmpty)
                                Text('Size: ${item['size']}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey[700])),
                              const SizedBox(height: 2),
                              Text(
                                  'Temperature: ${item['temperature'] ?? '-'} • Sugar: ${item['sugar'] ?? '-'}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey[700])),
                              if (item['notes'] != null &&
                                  item['notes'].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text('Note: ${item['notes']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.blue[700],
                                          fontStyle: FontStyle.italic)),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                CurrencyFormatter.formatCurrency(
                                    (item['price'] * (item['quantity'] ?? 1))
                                        .toInt()),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('x${item['quantity']}',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),
                infoRow("Total Order", "${items.length} items"),
                infoRow("Total Price",
                    CurrencyFormatter.formatCurrency(totalPrice)),
                const SizedBox(height: 16),
                if (status == 'completed')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Selesai',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  )
                else
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: orderId != null
                              ? () async {
                                  await orderController.markDone(orderId);
                                  await orderController.fetchAllOrders();
                                  Get.back();
                                  Get.snackbar(
                                      'Sukses', 'Order selesai (completed)');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 164, 159, 10),
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
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol print ulang di kanan tombol Selesaikan
                        IconButton(
                          onPressed: () async {
                            final orderData = {
                              'id': orderId,
                              'customer_name': customerName,
                              'items': items,
                              'total_price': totalPrice,
                              'payment_method': paymentMethod,
                              'location': location,
                              'order_type': orderType,
                              'notes': notes,
                              'created_at': created_at,
                            };
                            await bluetoothPrinterController
                                .printReceipt(orderData);
                          },
                          icon: const Icon(Icons.print),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
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
