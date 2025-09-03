import 'package:get/get.dart';
import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var orderHistory = <HistoryModel>[].obs;
  var selectedDate = DateTime.now().obs;
  var filteredHistory = <HistoryModel>[].obs;

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
      filterHistoryByDate(selectedDate.value);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterHistoryByDate(DateTime date) {
    selectedDate.value = date;
    final targetDate = DateTime(date.year, date.month, date.day);

    filteredHistory.assignAll(orderHistory.where((order) {
      if (order.createdAt == null || order.createdAt!.isEmpty) return false;

      try {
        final orderDate = DateTime.parse(order.createdAt!);
        final orderDateOnly =
            DateTime(orderDate.year, orderDate.month, orderDate.day);
        return orderDateOnly.isAtSameMomentAs(targetDate);
      } catch (e) {
        return false;
      }
    }).toList());
  }

  void selectDate(DateTime date) {
    filterHistoryByDate(date);
  }
}
