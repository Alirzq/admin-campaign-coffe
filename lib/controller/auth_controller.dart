import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  final box = GetStorage();

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['success'] == true) {
          final token = data['data']['token'];
          final user = data['data']['user'];
          if (token != null) {
            box.write('token', token);
            print('TOKEN YANG DISIMPAN: $token');
          }
          if (user != null) {
            box.write('user', user); // <-- Tambahkan baris ini!
            print('USER YANG DISIMPAN: $user');
          }
          Get.offAllNamed('/home');
        } else {
          errorMessage.value = data?['message'] ?? 'Login gagal';
          Get.offAllNamed('/home');
        }
      } else {
        print('LOGIN ERROR RESPONSE: ${response.body}');
        try {
          final data = jsonDecode(response.body);
          if (data['message'] is Map && data['message']['message'] != null) {
            errorMessage.value = data['message']['message'];
          } else if (data['message'] != null &&
              data['message'].toString().isNotEmpty) {
            errorMessage.value = data['message'].toString();
          } else {
            errorMessage.value = response.body;
          }
        } catch (_) {
          errorMessage.value = response.body.isNotEmpty
              ? response.body
              : 'Terjadi kesalahan. Kode status: ${response.statusCode}';
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.remove('token');
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
