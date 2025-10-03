import 'package:get/get.dart';
import '../models/earnings_model.dart';
import '../services/earnings_service.dart';
import 'dart:async';

class EarningsController extends GetxController {
  final earnings = <Earnings>[].obs;
  final totalEarnings = 0.0.obs;
  final isLoading = false.obs;
  final selectedMonth = ''.obs;

  final EarningsService _service = EarningsService();

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
    // Auto-refresh setiap 5 menit
    Timer.periodic(const Duration(minutes: 5), (timer) {
      if (!isLoading.value && Get.isDialogOpen == false) fetchEarnings();
    });
  }

  void fetchEarnings({String? month}) async {
    try {
      isLoading.value = true;
      final result = await _service.fetchEarnings(month: month ?? DateTime.now().toIso8601String().substring(0, 7));
      earnings.assignAll(result.orders);
      totalEarnings.value = result.total;
      selectedMonth.value = month ?? DateTime.now().toIso8601String().substring(0, 7);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateMonth(String month) {
    selectedMonth.value = month;
    fetchEarnings(month: month);
  }
}