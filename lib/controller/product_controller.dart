import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<Product> _products = <Product>[].obs;
  final categories = ["Coffee", "Non Coffee", "Snack", "Main Course"].obs;
  final selectedCategoryIndex = 0.obs;
  final RxMap<String, int> stockAmounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({String? search}) async {
    try {
      final products = await _productService.getProducts(search: search);
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
              'amount': getFormattedAmount(product.name),
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

  // Fungsi validasi input maksimal 100.000
  bool isValidAmount(int value) {
    return value <= 100000;
  }

  // Fungsi format angka ribuan
  String formatNumber(int value) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(value);
  }

  // Ambil jumlah stok terformat
  String getFormattedAmount(String productName) {
    final value = stockAmounts[productName] ?? 0;
    return formatNumber(value);
  }

  // Set jumlah stok dengan validasi
  bool setStockAmount(String productName, int value) {
    if (isValidAmount(value)) {
      stockAmounts[productName] = value;
      update();
      return true;
    }
    return false;
  }

  Future<Product> getProductById(int id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail produk', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> updateProduct({
    required int id,
    required String title,
    required String description,
    required String price,
    required String stock,
    required int categoryId,
    double rating = 0,
    int reviewCount = 0,
  }) async {
    try {
      await _productService.updateProduct(
        id: id,
        title: title,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        rating: rating,
        reviewCount: reviewCount,
      );
      await fetchProducts();
      Get.snackbar('Sukses', 'Produk berhasil diupdate', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal update produk', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      await fetchProducts();
      Get.snackbar('Sukses', 'Produk berhasil dihapus', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk', snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  // Add this getter
  List<Product> get products => _products;
}
