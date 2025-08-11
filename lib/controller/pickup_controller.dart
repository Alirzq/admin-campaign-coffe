import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/services/order_service.dart';
import '../models/order_model.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 


class PickupController extends GetxController {
  final OrderService _orderService = OrderService();

  var orderList = <Order>[].obs;
  var inProgressList = <Order>[].obs;
  var deliverList = <Order>[].obs;

  @override
  void onInit() {
    fetchAllOrders();
    super.onInit();
  }

  Future<void> fetchAllOrders() async {
    try {
      final paid = await _orderService.getPickupOrdersByStatus('paid');
      final inprogress = await _orderService.getPickupOrdersByStatus('inprogress');
      final completed = await _orderService.getPickupOrdersByStatus('completed');
      orderList.value = paid.where((o) => o.orderType == 'pickup').toList();
      inProgressList.value = inprogress.where((o) => o.orderType == 'pickup').toList();
      deliverList.value = completed.where((o) => o.orderType == 'pickup').toList();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> acceptOrder(int id) async {
    await _orderService.updateOrderStatus(id, 'inprogress');
    await fetchAllOrders(); // refresh
  }

  Future<void> markDone(int id) async {
    await _orderService.updateOrderStatus(id, 'completed');
    await fetchAllOrders(); // refresh
  }

}