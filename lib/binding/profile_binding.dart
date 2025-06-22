import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
