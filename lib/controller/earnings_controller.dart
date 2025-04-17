import 'package:get/get.dart';

class EarningsController extends GetxController {
  var isStoreOpen = true.obs;

  void toggleStore(bool value) {
    isStoreOpen.value = value;
  }

  var newOrders = [
    {
      'orderName': 'Order #001',
      'orderItems': '2x Burger, 1x Fries',
      'price': 'Rp 120.000',
    },
    {
      'orderName': 'Order #002',
      'orderItems': '1x Pizza, 2x Coke',
      'price': 'Rp 150.000',
    },
  ].obs;
}
