import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupOrderCard extends StatelessWidget {
  final String pickupName;
  final String pickupItems;
  final String price;
  final VoidCallback? onTap;
  final List<String> items;

  const PickupOrderCard({
    Key? key,
    required this.pickupName,
    required this.pickupItems,
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
            Text(pickupName,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Order Items', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const Divider(),
            if (items.isNotEmpty)
              ...items.map((item) => Text(item, style: GoogleFonts.poppins(fontSize: 14))),
            if (items.isEmpty)
              Text(pickupItems, style: GoogleFonts.poppins(fontSize: 14)),
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
