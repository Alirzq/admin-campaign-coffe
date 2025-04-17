import 'package:get/get.dart';

class HomePageController extends GetxController {
  var isStoreOpen = true.obs;

  var newOrders = [
    {
      'orderName': 'Chucu-Chaca',
      'orderItems': 'Chocolate, Taro Milk, Red Velvet',
      'price': 'Rp. 15.000',
    },
    {
      'orderName': 'Boba Corner',
      'orderItems': 'Matcha Latte, Brown Sugar Boba',
      'price': 'Rp. 25.000',
    },
    {
      'orderName': 'Milk Bar',
      'orderItems': 'Vanilla Milk, Thai Tea',
      'price': 'Rp. 20.000',
    },
  ].obs;

  void toggleStore(bool value) {
    isStoreOpen.value = value;
  }
}

class HomepageController extends GetxController {
  RxBool isStoreOpen = false.obs;

  void toggleStore(bool value) {
    isStoreOpen.value = value;
  }
}
