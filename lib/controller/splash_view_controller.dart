import 'package:get/get.dart';
import '../app/modules/pages/welcome/view/welcome_screen.dart'; // Import welcome screen

class SplashViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Menambahkan jeda sebelum berpindah ke WelcomeScreen
    Future.delayed(Duration(seconds: 1), () {
      Get.off(() => WelcomeScreen()); // Navigate to Welcome Screen
    });
  }
}
