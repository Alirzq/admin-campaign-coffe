import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/modules/pages/homepage/view/admin_homepage_view.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());

  var errorMessage = ''.obs;

  void onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    }
  }

  void verifyOtp() {
    String otpCode = otpControllers.map((e) => e.text).join();
    if (otpCode.length < 5) {
      errorMessage.value = "Please enter a valid OTP.";
    } else {
      errorMessage.value = '';
      Get.offAllNamed('/home');
    }
  }

  void resendOtp() {
    errorMessage.value = "OTP has been resent.";
  }
}
