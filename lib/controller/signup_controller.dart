import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  var errorMessage = ''.obs;
  var isLoading = false.obs;

  Future<void> signUp() async {
    // Validasi lokal
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      errorMessage.value = "Mohon isi semua kolom dengan lengkap.";
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = "Kata sandi dan konfirmasi kata sandi tidak cocok.";
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
        Uri.parse('https://campaign.rplrus.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phone': phoneController.text.trim(),
        }),
      )
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.isEmpty) {
        errorMessage.value = 'Respons server kosong. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Sukses',
          (data['data'] != null && data['data']['message'] != null)
              ? data['data']['message']
              : 'Registrasi berhasil! Silakan cek email Anda untuk verifikasi.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/email-verification',
            arguments: emailController.text.trim());
      } else {
        errorMessage.value =
            (data['data'] != null && data['data']['message'] != null)
                ? data['data']['message']
                : 'Registrasi gagal. Silakan coba lagi.';
        if (data['data'] != null && data['data']['errors'] != null) {
          errorMessage.value = data['data']['errors'].values.join(', ');
        }
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mendaftar: ${e.toString()}.';
      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during signup: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
