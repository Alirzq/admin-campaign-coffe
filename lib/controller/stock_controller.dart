import 'package:get/get.dart';
import '../app/modules/api/models/product_model.dart';
import '../app/modules/api/services/product_service.dart';

class StockController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<Product> _products = <Product>[].obs;
  final categories =
      ["Coffee", "Non Coffee", "Snack", "Main Course", "Noodles"].obs;
  final selectedCategoryIndex = 0.obs;
  final RxMap<String, int> stockAmounts = <String, int>{}.obs;

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
              'amount': stockAmounts[product.name]?.toString() ?? '0',
              'image': product.image,
            })
        .toList();
  }

  void incrementStock(String productName) {
    final currentAmount = stockAmounts[productName] ?? 0;
    stockAmounts[productName] = currentAmount + 1;
    update();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}
