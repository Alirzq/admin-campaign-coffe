import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../one_time_password/view/otp_view.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var errorMessage = ''.obs; // Error message yang akan muncul di atas form

  void login() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = 'Username dan password harus diisi!';
      return;
    }

    errorMessage.value = ''; // Hapus error jika input valid
    Get.to(() => OtpView());
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
