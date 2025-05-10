import 'dart:convert';
import 'package:admin_campaign_coffe_repo/app/modules/pages/homepage/view/admin_homepage_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password harus diisi!';
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Periksa status kode HTTP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Jika tidak ada status sukses, langsung ke HomepageView
        if (data == null || data['status'] != true) {
          Get.offAllNamed(
              '/home'); // Menggunakan offAllNamed untuk mengganti route
          errorMessage.value = data?['message'] ?? 'Login gagal';
        } else {
          Get.offAllNamed(
              '/home'); // Menggunakan offAllNamed untuk mengganti route
        }
      } else {
        errorMessage.value =
            'Terjadi kesalahan. Kode status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
