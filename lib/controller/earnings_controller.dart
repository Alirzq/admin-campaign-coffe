import 'package:get/get.dart';
import '../models/earnings_model.dart';
import '../services/earnings_service.dart';

class EarningsController extends GetxController {
  final earnings = <Earnings>[].obs;
  final totalEarnings = 0.obs;
  final isLoading = false.obs;
  final selectedMonth = ''.obs;
  final averagePerWeek = 0.obs;
  final growthPercentage = 0.obs;


  final EarningsService _service = EarningsService();

  @override
  void onInit() {
    fetchEarnings();
    super.onInit();
  }

  void fetchEarnings({String? month}) async {
  try {
    isLoading.value = true;
    final result = await _service.fetchEarnings(month: month);
    earnings.assignAll(result.orders);
    totalEarnings.value = result.total.toInt();
    averagePerWeek.value = result.averagePerWeek.toInt();
    growthPercentage.value = result.growthPercentage.toInt();
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