import 'package:get/get.dart';
import '../services/product_service.dart';

class CustomAddMenuController extends GetxController {
  var selectedCategoryIndex = 0.obs;

  final categories = [
    'Coffee',
    'Non Coffee',
    'Snack',
    'Main Course',
    'Noodles',
  ];

  final categoryIcons = {
    'Coffee': 'assets/coffee.svg',
    'Non Coffee': 'assets/non_coffee.svg',
    'Snack': 'assets/snack.svg',
    'Main Course': 'assets/main_course.svg',
    'Noodles': 'assets/noodles.svg',
  };

  final ProductService productService = ProductService();

  final Map<String, int> categoryIdMap = {
    'Coffee': 1,
    'Non Coffee': 2,
    'Snack': 3,
    'Main Course': 4,
    'Noodles': 4, // Noodles masuk ke Main Course
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
  }) async {
    try {
      await productService.addProduct(
        title: title,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        rating: 0,
        reviewCount: 0,
      );
      Get.snackbar('Sukses', 'Menu berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
