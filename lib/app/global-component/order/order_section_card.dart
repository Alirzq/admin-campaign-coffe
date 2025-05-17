import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_card.dart';

class OrderSectionCard extends StatelessWidget {
  final String title;
  final Map<String, String> data;
  final VoidCallback onTap;

  const OrderSectionCard({
    super.key,
    required this.title,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue.shade900,
                ),
              ),
              TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
          OrderCard(
            orderName: data['orderName']!,
            orderItems: data['orderItems']!,
            price: data['price']!,
          ),
        ],
      ),
    );
  }
}
