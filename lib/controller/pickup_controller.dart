import 'package:get/get.dart';

class PickupController extends GetxController {
  final RxList<Map<String, String>> pickupList = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> inProgressPickupList =
      <Map<String, String>>[].obs;
  final RxList<Map<String, String>> completedPickupList =
      <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateSampleData();
  }

  void generateSampleData() {
    // Sample data for new pickups
    pickupList.addAll([
      {
        'pickupName': 'John Doe',
        'pickupItems': 'Chocolate, Taro Latte',
        'price': 'Rp 45.000',
      },
      {
        'pickupName': 'Jane Smith',
        'pickupItems': 'Caramel Macchiato, Green Tea',
        'price': 'Rp 50.000',
      },
    ]);

    // Sample data for in-progress pickups
    inProgressPickupList.addAll([
      {
        'pickupName': 'Mike Johnson',
        'pickupItems': 'Espresso, Cappuccino',
        'price': 'Rp 40.000',
      },
      {
        'pickupName': 'Sarah Wilson',
        'pickupItems': 'Mocha, Vanilla Latte',
        'price': 'Rp 55.000',
      },
    ]);

    // Sample data for completed pickups
    completedPickupList.addAll([
      {
        'pickupName': 'David Brown',
        'pickupItems': 'Americano, Latte',
        'price': 'Rp 35.000',
      },
      {
        'pickupName': 'Lisa Anderson',
        'pickupItems': 'Frappuccino, Hot Chocolate',
        'price': 'Rp 60.000',
      },
    ]);
  }
}
