import 'package:get/get.dart';
import '../services/earnings_service.dart';
import '../utils/error_utils.dart';

class MonthlyTotalPerMonth {
  final int month;
  final double total;

  MonthlyTotalPerMonth({required this.month, required this.total});
}

class MonthlyEarningsController extends GetxController {
  final EarningsService _service = EarningsService();

  final RxInt selectedYear = DateTime.now().year.obs;
  final RxBool isLoading = false.obs;
  final RxList<MonthlyTotalPerMonth> monthlyTotals =
      <MonthlyTotalPerMonth>[].obs;

  List<int> get availableYears {
    final current = DateTime.now().year;
    final end = 2050;
    final start = current - 5; // beri opsi mundur 5 tahun dari tahun berjalan
    return List<int>.generate(end - start + 1, (i) => start + i);
  }

  @override
  void onInit() {
    super.onInit();
    loadYear(selectedYear.value);
  }

  Future<void> loadYear(int year) async {
    selectedYear.value = year;
    isLoading.value = true;
    try {
      // Fetch sequential untuk menghindari 429 Throttle
      final List<MonthlyTotalPerMonth> results = [];
      for (int index = 0; index < 12; index++) {
        final month = index + 1;
        final monthString = _toYearMonth(year, month);
        final response = await _service.fetchEarnings(month: monthString);
        // Hanya tambahkan bulan yang memiliki data (total > 0)
        if (response.total > 0) {
          results
              .add(MonthlyTotalPerMonth(month: month, total: response.total));
        }
        await Future.delayed(const Duration(milliseconds: 120));
      }
      results.sort((a, b) => a.month.compareTo(b.month));
      monthlyTotals.assignAll(results);
    } catch (e) {
      Get.snackbar('Error', ErrorUtils.friendlyMessage(e));
      monthlyTotals.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String _toYearMonth(int year, int month) {
    final two = month < 10 ? '0$month' : '$month';
    return '$year-$two';
  }
}
