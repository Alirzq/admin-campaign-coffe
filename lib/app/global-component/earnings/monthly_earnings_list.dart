import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/currency_formatter.dart';

class MonthlyEarningsItemData {
  final String monthLabel;
  final double total;
  final VoidCallback? onTap;

  MonthlyEarningsItemData(
      {required this.monthLabel, required this.total, this.onTap});
}

class MonthlyEarningsList extends StatelessWidget {
  final List<MonthlyEarningsItemData> items;

  const MonthlyEarningsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 0,
          color: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _monthShort(item.monthLabel),
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // Hapus label bulan-tahun sesuai permintaan
            trailing: Text(
              CurrencyFormatter.formatCurrencyFromDouble(item.total),
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.w800,
                color: Colors.blue.shade900,
              ),
            ),
            onTap: item.onTap,
          ),
        );
      },
    );
  }
}

String _monthShort(String label) {
  // ekspektasi label: "Januari 2025" -> kembalikan "Jan"
  final parts = label.split(' ');
  final month = parts.isNotEmpty ? parts.first : label;
  const map = {
    'Januari': 'Jan',
    'Februari': 'Feb',
    'Maret': 'Mar',
    'April': 'Apr',
    'Mei': 'Mei',
    'Juni': 'Jun',
    'Juli': 'Jul',
    'Agustus': 'Agu',
    'September': 'Sep',
    'Oktober': 'Okt',
    'November': 'Nov',
    'Desember': 'Des',
  };
  return map[month] ?? month.substring(0, month.length >= 3 ? 3 : month.length);
}
