import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/modules/pages/one_time_password/view/otp_view.dart';

class SignupController extends GetxController {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  var errorMessage = ''.obs;

  void signUp() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      errorMessage.value = "All fields must be filled!";
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = "Passwords do not match!";
      return;
    }

    // Clear error message
    errorMessage.value = '';

    // Navigate to OTP page
    Get.to(() => OtpView());
  }
}
