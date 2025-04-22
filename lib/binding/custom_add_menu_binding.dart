import 'package:get/get.dart';
import '../controller/custom_add_menu_controller.dart';

class CustomAddMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomAddMenuController>(() => CustomAddMenuController());
  }
}
