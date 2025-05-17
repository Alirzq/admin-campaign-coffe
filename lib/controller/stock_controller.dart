import 'package:get/get.dart';
import '../app/data/models/product_model.dart';
import '../app/data/services/product_service.dart';

class StockController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<Product> _products = <Product>[].obs;
  final categories =
      ["Coffee", "Non Coffee", "Snack", "Main Course", "Noodles"].obs;
  final selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await _productService.getProducts();
      _products.assignAll(products);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data produk',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<Map<String, dynamic>> get filteredStock {
    final selectedCategory = categories[selectedCategoryIndex.value];
    return _products
        .where((product) => product.category == selectedCategory)
        .map((product) => {
              'title': product.name,
              'desc': product.description,
              'amount': product.price,
              'image': product.image,
            })
        .toList();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}
