import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class StockController extends GetxController {
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

  Future<void> fetchProducts() async {
    try {
      print('FETCH PRODUCTS: Memulai fetch produk...');
      final products = await _productService.getProducts();
      print(
          'FETCH PRODUCTS: Produk berhasil diambil, jumlah: ${products.length}');
      _products.assignAll(products);
    } catch (e) {
      print('FETCH PRODUCTS ERROR: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data produk',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> searchProducts(String search) async {
    try {
      final products = await _productService.getProducts(search: search);
      _products.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mencari produk',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<Map<String, dynamic>> get filteredStock {
    final selectedCategory = categories[selectedCategoryIndex.value];
    return _products
        .where((product) => product.category == selectedCategory)
        .map((product) => {
              'title': product.name,
              'desc': product.description,
              'amount': product.stock.toString(), // ambil langsung dari backend
              'image': product.image,
            })
        .toList();
  }

  List<Product> get products => _products;

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

  // Set jumlah stok dengan validasi dan update ke backend
  Future<bool> setStockAmountByName(String productName, int value) async {
    if (!isValidAmount(value)) return false;
    try {
      // Cari produk berdasarkan nama
      final product = _products.firstWhereOrNull((p) => p.name == productName);
      print('UPDATE STOK: Cari produk dengan nama: $productName');
      if (product == null) {
        print('UPDATE STOK: Produk tidak ditemukan!');
        return false;
      }
      print('UPDATE STOK: Update stok produk id=${product.id} ke $value');
      final success =
          await _productService.updateProductStock(product.id, value);
      print('UPDATE STOK: Status update ke backend: $success');
      if (success) {
        await fetchProducts(); // Refresh data dari backend
        update();
        return true;
      }
      return false;
    } catch (e) {
      print('UPDATE STOK ERROR: $e');
      return false;
    }
  }
}
