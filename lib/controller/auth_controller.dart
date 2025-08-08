import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app/modules/pages/login/view/ResetPassView.dart';

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
      errorMessage.value = 'Mohon masukkan email dan kata sandi.';
      Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://a7d765cc68b7.ngrok-free.app/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['data']['token'];
        final user = data['data']['user'];
        if (token != null) {
          box.write('token', token);
          print('TOKEN YANG DISIMPAN: $token');
        }
        if (user != null) {
          box.write('user', user);
          print('USER YANG DISIMPAN: $user');
        }
        Get.snackbar(
          'Sukses',
          data['data']['message'] ?? 'Login berhasil! Selamat datang kembali.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = data['data']['message'] ?? 'Login gagal. Silakan coba lagi.';
        if (data['data']['errors'] != null) {
          errorMessage.value = data['data']['errors'].values.join(', ');
        }
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat login. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    Get.snackbar('Sukses', 'Anda telah logout.', backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAllNamed('/login');
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Mohon masukkan email Anda.';
      Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://a7d765cc68b7.ngrok-free.app/api/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.defaultDialog(
          title: 'Reset Kata Sandi',
          middleText: 'Link reset kata sandi telah dikirim ke email Anda.',
          textConfirm: 'Lanjutkan',
          onConfirm: () {
            Get.back();
            Get.toNamed('/reset-password');
          },
          textCancel: 'Tutup',
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue.shade900,
        );
      } else {
        errorMessage.value = data['data']['message'] ?? 'Gagal mengirim link reset kata sandi.';
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mengirim link reset. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during forgot password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (email.isEmpty || token.isEmpty || password.isEmpty || passwordConfirmation.isEmpty) {
      errorMessage.value = 'Mohon isi semua kolom dengan lengkap.';
      Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (password != passwordConfirmation) {
      errorMessage.value = 'Kata sandi dan konfirmasi kata sandi tidak cocok.';
      Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://a7d765cc68b7.ngrok-free.app/api/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          data['data']['message'] ?? 'Kata sandi berhasil direset. Silakan login dengan kata sandi baru.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      } else {
        errorMessage.value = data['data']['message'] ?? 'Gagal mereset kata sandi. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mereset kata sandi. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during reset password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Mohon masukkan email Anda.';
      Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://a7d765cc68b7.ngrok-free.app/api/email/resend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          data['data']['message'] ?? 'Link verifikasi baru telah dikirim ke email Anda.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = data['data']['message'] ?? 'Gagal mengirim link verifikasi. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mengirim link verifikasi. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during resend verification: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Starting Google Sign-In...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        isLoading.value = false;
        errorMessage.value = 'Login dengan Google dibatalkan.';
        Get.snackbar('Peringatan', errorMessage.value, backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      print('Google Sign-In successful, getting authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      print('ID Token: $idToken');
      if (idToken == null) {
        print('ID Token is null');
        errorMessage.value = 'Gagal login dengan Google. Silakan coba lagi.';
        isLoading.value = false;
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      print('Sending request to server...');
      final response = await http.post(
        Uri.parse('https://a7d765cc68b7.ngrok-free.app/api/auth/google/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      print('Server Response: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        box.write('token', data['data']['token']);
        box.write('user', data['data']['user']);
        Get.snackbar(
          'Sukses',
          data['data']['message'] ?? 'Login dengan Google berhasil! Selamat datang.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = data['data']['message'] ?? 'Gagal login dengan Google. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        print('Login failed: ${data['data']['message']}');
      }
    } catch (e) {
      print('Error during Google Login: $e');
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat login dengan Google. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
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