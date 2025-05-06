import 'package:get/get.dart';

class NavbarController extends GetxController {
  final currentRoute = ''.obs;

  void updateRoute(String route) {
    currentRoute.value = route;
  }
}
