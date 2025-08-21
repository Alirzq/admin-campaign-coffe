import 'package:get/get.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';
import 'dart:io';

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

  // Hapus snackbar dari controller, biarkan UI yang handle
  Future<Promotion> addPromotion(String title, {String? image}) async {
    isLoading.value = true;
    try {
      final promo = await service.addPromotion(title, image: image);
      promotions.add(promo); // Tambahkan ke daftar setelah berhasil
      return promo; // Kembalikan promo yang berhasil ditambahkan
    } catch (e) {
      rethrow; // Lempar ulang error agar bisa ditangani di pemanggil
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> uploadPromotionImage(File imageFile) async {
    isLoading.value = true;
    try {
      final filename = await service.uploadImage(imageFile);
      isLoading.value = false;
      return filename;
    } catch (e) {
      isLoading.value = false;
      // Tetap tampilkan error snackbar karena ini method utility
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  // Hapus snackbar dari controller, biarkan UI yang handle
  Future<void> deletePromotion(int id) async {
    isLoading.value = true;
    try {
      await service.deletePromotion(id);
      promotions.removeWhere((p) => p.id == id);
    } catch (e) {
      // Tetap tampilkan error snackbar
      Get.snackbar('Error', e.toString());
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
