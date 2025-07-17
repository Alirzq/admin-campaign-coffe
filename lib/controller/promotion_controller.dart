import 'package:get/get.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';

class PromotionController extends GetxController {
  var promotions = <Promotion>[].obs;
  var isLoading = false.obs;
  final service = PromotionService();

  @override
  void onInit() {
    fetchPromotions();
    super.onInit();
  }

  void fetchPromotions() async {
    isLoading.value = true;
    try {
      promotions.value = await service.fetchPromotions();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }

  void addPromotion(String title, {String? image}) async {
    isLoading.value = true;
    try {
      final promo = await service.addPromotion(title, image: image);
      promotions.add(promo);
      Get.snackbar('Success', 'Promotion added');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }

  void deletePromotion(int id) async {
    isLoading.value = true;
    try {
      await service.deletePromotion(id);
      promotions.removeWhere((p) => p.id == id);
      Get.snackbar('Success', 'Promotion deleted');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }
}
