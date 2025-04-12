import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global-component/graph_component/line_chart_widget.dart';
import '../../../../global-component/stat_card.dart';

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summary This week",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 12),
                const LineChartWidget(),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
