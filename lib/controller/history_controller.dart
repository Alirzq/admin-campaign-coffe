import 'package:get/get.dart';
import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var orderHistory = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    isLoading.value = true;
    try {
      final data = await HistoryService.fetchOrderHistory();
      orderHistory.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
