import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../app/modules/pages/login/view/login_view.dart';
import '../app/modules/pages/welcome/view/welcome_screen.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1), () {
      final context = Get.context!;
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      final isTablet = shortestSide >= 600;

      // Set orientasi berdasarkan jenis perangkat
      _setOrientationBasedOnDevice(isTablet);

      if (isTablet) {
        Get.off(() => LoginView()); // Tablet langsung ke login
      } else {
        Get.off(() => WelcomeScreen()); // HP ke welcome dulu
      }
    });
  }

  void _setOrientationBasedOnDevice(bool isTablet) {
    if (isTablet) {
      // Tablet: izinkan landscape dan portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // HP: hanya portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
