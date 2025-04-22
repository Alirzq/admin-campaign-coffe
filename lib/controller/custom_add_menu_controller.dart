import 'package:get/get.dart';

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

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}
