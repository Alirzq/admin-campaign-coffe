import 'package:admin_campaign_coffe_repo/app/modules/pages/custom_widgets/view/custom_add_banner_view.dart';
import 'package:admin_campaign_coffe_repo/app/modules/pages/custom_widgets/view/custom_add_menu_view.dart';
import 'package:admin_campaign_coffe_repo/binding/custom_add_menu_binding.dart';
import 'package:admin_campaign_coffe_repo/binding/custom_add_banner_binding.dart';

import 'package:get/get.dart';

class CustomWidgetController extends GetxController {
  void goToBanner() {
    Get.to(() => const CustomAddBannerView(),
        binding: CustomAddBannerBinding());
  }

  void goToAddMenuWidget() {
    Get.to(() => CustomAddMenuView(), binding: CustomAddMenuBinding());
  }

  void goToAddBannerWidget() {
    Get.to(() => const CustomAddBannerView(),
        binding: CustomAddBannerBinding());
  }
}
