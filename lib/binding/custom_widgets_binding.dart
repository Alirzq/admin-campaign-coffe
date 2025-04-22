import 'package:admin_campaign_coffe_repo/controller/custom_widgets_controller.dart';
import 'package:get/get.dart';

class CustomWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomWidgetController>(() => CustomWidgetController());
  }
}
