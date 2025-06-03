import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxList<Map<String, String>> orderHistory = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Data dummy untuk history
    orderHistory.addAll([
      {
        'orderName': 'Pesanan #001',
        'orderItems': 'Cappuccino x2, Latte x1',
        'price': 'Rp 75.000',
      },
      {
        'orderName': 'Pesanan #002',
        'orderItems': 'Americano x1, Mocha x2',
        'price': 'Rp 85.000',
      },
      {
        'orderName': 'Pesanan #003',
        'orderItems': 'Espresso x1, Caramel Macchiato x1',
        'price': 'Rp 65.000',
      },
      {
        'orderName': 'Pesanan #004',
        'orderItems': 'Cold Brew x2, Frappuccino x1',
        'price': 'Rp 95.000',
      },
    ]);
  }
}
