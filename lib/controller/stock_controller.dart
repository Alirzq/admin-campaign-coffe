import 'package:get/get.dart';

class StockController extends GetxController {
  final categories =
      ["Coffee", "Non Coffee", "Snack", "Main Course", "Noodles"].obs;
  final selectedCategoryIndex = 0.obs;

  final allStock = <Map<String, dynamic>>[
    {
      'title': 'Oat',
      'desc': 'Chocolate',
      'image': 'assets/dummy_drink.png',
      'amount': 12,
      'category': 'Non Coffee'
    },
    {
      'title': 'Taro',
      'desc': 'Chocolate',
      'image': 'assets/dummy_drink.png',
      'amount': 12,
      'category': 'Non Coffee'
    },
    {
      'title': 'Matcha',
      'desc': 'Chocolate',
      'image': 'assets/dummy_drink.png',
      'amount': 12,
      'category': 'Non Coffee'
    },
    {
      'title': 'Strawberry',
      'desc': 'Chocolate',
      'image': 'assets/dummy_drink.png',
      'amount': 12,
      'category': 'Non Coffee'
    },
    {
      'title': 'Roti',
      'desc': 'Chocolate',
      'image': 'assets/dummy_drink.png',
      'amount': 12,
      'category': 'Main Course'
    },
  ].obs;

  List<Map<String, dynamic>> get filteredStock {
    final selectedCategory = categories[selectedCategoryIndex.value];
    return allStock
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}
