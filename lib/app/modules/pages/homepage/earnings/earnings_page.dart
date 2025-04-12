import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global-component/order_card.dart';
import '../../../../global-component/stat_card.dart';

class EarningsPage extends StatelessWidget {
  final bool isStoreOpen;
  final Function(bool) onToggleStore;

  const EarningsPage({Key? key, required this.isStoreOpen, required this.onToggleStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Open Toggle
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 350),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store, color: Colors.blue.shade900, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Store is ${isStoreOpen ? "Open" : "Closed"}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isStoreOpen,
                    onChanged: onToggleStore,
                    activeColor: Colors.blue.shade900,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  "Total Sales",
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.blue.shade900),
                ),
                Text(
                  "Rp 500.000",
                  style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.blue.shade900),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                title: "Avg Per Week",
                value: "Rp 500.000",
                titleColor: const Color.fromARGB(255, 98, 98, 98),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w600,
                valueFontWeight: FontWeight.w800,
              ),
              StatCard(
                title: "Formings Growth",
                value: "12%",
                titleColor: const Color.fromARGB(255, 98, 98, 98),
                valueColor: const Color.fromARGB(255, 98, 98, 98),
                titleFontWeight: FontWeight.w600,
                valueFontWeight: FontWeight.w800,
              ),
            ],
          ),

          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
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
                      "New Order",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.blue.shade900),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      OrderCard(orderName: "Chucu-Chaca", orderItems: "Chocolate, Taro Milk, Red Velvet", price: "Rp. 15.000"),
                      OrderCard(orderName: "Chucu-Chaca", orderItems: "Chocolate, Taro Milk, Red Velvet", price: "Rp. 15.000"),
                      OrderCard(orderName: "Chucu-Chaca", orderItems: "Chocolate, Taro Milk, Red Velvet", price: "Rp. 15.000"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
