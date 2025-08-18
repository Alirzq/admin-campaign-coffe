import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import 'dart:io';

class CustomAddMenuController extends GetxController {
  var selectedCategoryIndex = (-1).obs; // Changed to -1 as initial value
  final categories = [
    'Coffee',
    'Non Coffee',
    'Snack',
    'Main Course',
  ];
  final categoryIcons = {
    'Coffee': 'assets/coffee.svg',
    'Non Coffee': 'assets/non_coffee.svg',
    'Snack': 'assets/snack.svg',
    'Main Course': 'assets/main_course.svg',
  };
  final ProductService productService = ProductService();
  final Map<String, int> categoryIdMap = {
    'Coffee': 1,
    'Non Coffee': 2,
    'Snack': 3,
    'Main Course': 4,
  };

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void addMenu({
    required String title,
    required String description,
    required String price,
    required String stock,
    required int categoryId,
    File? imageFile,
    VoidCallback? onSuccess, // Callback untuk clear fields
  }) async {
    try {
      String? imagePath;
      // Upload gambar jika ada, dengan type 'menu'
      if (imageFile != null) {
        imagePath = await productService.uploadImage(imageFile, 'menu');
      }

      await productService.addProduct(
        title: title,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        rating: 0,
        reviewCount: 0,
        imagePath: imagePath,
      );

      // Close loading dialog first
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show success message
      Get.snackbar(
        'Sukses',
        'Menu berhasil ditambahkan',
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      // Clear all fields and reset form
      selectedCategoryIndex.value = -1;
      if (onSuccess != null) {
        onSuccess(); // Call callback to clear text controllers and image
      }
    } catch (e) {
      // Close loading dialog if error occurs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }
}
