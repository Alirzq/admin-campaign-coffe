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
      orderList.value = await _orderService.getPickupOrdersByStatus('paid');
      inProgressList.value = await _orderService.getPickupOrdersByStatus('inprogress');
      deliverList.value = await _orderService.getPickupOrdersByStatus('completed');
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
