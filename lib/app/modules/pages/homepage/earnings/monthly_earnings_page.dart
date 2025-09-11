import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/monthly_earnings_controller.dart';
import '../../../../../../utils/currency_formatter.dart';
import '../../../../global-component/earnings/monthly_earnings_list.dart';

class MonthlyEarningsPage extends StatelessWidget {
  const MonthlyEarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MonthlyEarningsController());
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Monthly Sales',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onRefresh: () async {
          await controller.loadYear(controller.selectedYear.value);
        },
        child: Padding(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month,
                                color: Colors.grey.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Pilih Tahun',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 20.0 : 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          return DropdownButton<int>(
                            value: controller.selectedYear.value,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18.0 : 14.0,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                            icon: const Icon(Icons.expand_more),
                            underline: const SizedBox.shrink(),
                            onChanged: (val) {
                              if (val != null) controller.loadYear(val);
                            },
                            items: controller.availableYears
                                .map((y) => DropdownMenuItem(
                                      value: y,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Text(y.toString()),
                                      ),
                                    ))
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Year summary card
                Obx(() {
                  final totalYear = controller.monthlyTotals
                      .fold<double>(0.0, (sum, e) => sum + e.total);
                  return Card(
                    elevation: 0,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24.0 : 16.0,
                          vertical: isTablet ? 20.0 : 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Tahun ${controller.selectedYear.value}',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 18.0 : 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.formatCurrencyFromDouble(
                                    totalYear),
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 28.0 : 22.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.stacked_bar_chart,
                              color: Colors.blue.shade700),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Per Bulan',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 18.0 : 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.monthlyTotals.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada pemasukan di tahun ini',
                          style: GoogleFonts.poppins(fontSize: 16.0),
                        ),
                      );
                    }

                    return MonthlyEarningsList(
                      items: controller.monthlyTotals
                          .map((e) => MonthlyEarningsItemData(
                                monthLabel:
                                    '${_monthName(e.month)} ${controller.selectedYear.value}',
                                total: e.total,
                                onTap: () async {
                                  final selected = await showMonthPicker(
                                    context,
                                    controller.selectedYear.value,
                                    e.month,
                                  );
                                  if (selected != null) {
                                    controller.loadYear(selected.year);
                                  }
                                },
                              ))
                          .toList(),
                    );
                  }),
                ),
              ],
            )),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
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
      'Desember',
    ];
    return names[month - 1];
  }
}

Future<DateTime?> showMonthPicker(
    BuildContext context, int year, int month) async {
  // Date picker versi 1 bulan: hanya mengizinkan memilih bulan (tahun tetap)
  // Untuk kesederhanaan, gunakan dialog sederhana memilih bulan dalam tahun yang dipilih
  return showDialog<DateTime>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Pilih Bulan'),
        content: SizedBox(
          width: 300,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(12, (index) {
              final m = index + 1;
              final label = _monthStaticName(m);
              final isSelected = m == month;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) {
                  Navigator.of(ctx).pop(DateTime(year, m));
                },
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          )
        ],
      );
    },
  );
}

String _monthStaticName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  return names[month - 1];
}
