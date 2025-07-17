// file: global-component/order_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final String orderName;
  final String orderItems;
  final String price;
  final VoidCallback? onTap;
  final List<String> items;

  const OrderCard({
    Key? key,
    required this.orderName,
    required this.orderItems,
    required this.price,
    this.onTap,
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderName,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Order Items', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const Divider(),
            if (items.isNotEmpty)
              ...items.map((item) => Text(item, style: GoogleFonts.poppins(fontSize: 14))),
            if (items.isEmpty)
              (orderItems.isEmpty || orderItems == '-')
                ? Text('Belum ada order.', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey))
                : Text(orderItems, style: GoogleFonts.poppins(fontSize: 14)),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(price,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
