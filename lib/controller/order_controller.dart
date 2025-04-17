import 'package:get/get.dart';

class OrderController extends GetxController {
  final orderList = List.generate(
    10,
    (index) => {
      'orderName': 'Customer ${index + 1}',
      'orderItems': 'Item A, Item B, Item C',
      'price': 'Rp. ${(index + 1) * 10000}',
    },
  );

  final inProgressList = List.generate(
    7,
    (index) => {
      'orderName': 'InProgress ${index + 1}',
      'orderItems': 'Cake ${index + 1}',
      'price': 'Rp. ${(index + 1) * 8000}',
    },
  );

  final deliverList = List.generate(
    5,
    (index) => {
      'orderName': 'Delivering ${index + 1}',
      'orderItems': 'Drink ${index + 1}',
      'price': 'Rp. ${(index + 1) * 9000}',
    },
  );
}
