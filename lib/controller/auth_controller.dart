import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app/modules/pages/login/view/ResetPassView.dart'; // jika dari root controller

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
        Uri.parse('https://e859900cec8a.ngrok-free.app/api/login'),
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

  /// Kirim link reset password ke email
  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await http.post(
        Uri.parse('https://6fe0ea5b97fd.ngrok-free.app/api/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.defaultDialog(
          title: 'Reset Password',
          middleText:
              'Silakan cek email Anda untuk mendapatkan token reset password.',
          textConfirm: 'Reset Password',
          onConfirm: () {
            Get.back();
            Get.to(() => ResetPasswordView());
          },
          textCancel: 'Tutup',
        );
      } else {
        errorMessage.value =
            data['message'] ?? 'Gagal mengirim email reset password';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset password dengan token dari email
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await http.post(
        Uri.parse('https://6fe0ea5b97fd.ngrok-free.app/api/reset-password'),
        body: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.statusCode == 200) {
        Get.snackbar('Sukses',
            'Password berhasil direset. Silakan login dengan password baru.');
        Get.offAllNamed('/login'); // atau Get.offAll(LoginView());
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['message'] ?? 'Reset password gagal';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value);
    }
    isLoading.value = false;
  }

  /// Resend email verifikasi
  Future<void> resendVerificationEmail(String email) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await http.post(
        Uri.parse('https://6fe0ea5b97fd.ngrok-free.app/api/email/resend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar('Sukses', data['message']);
      } else {
        errorMessage.value =
            data['message'] ?? 'Gagal mengirim ulang email verifikasi';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Sign In (gunakan package google_sign_in)
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('Starting Google Sign-In...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        isLoading.value = false;
        errorMessage.value = 'Login dibatalkan oleh pengguna.';
        return;
      }
      print('Google Sign-In successful, getting authentication...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      print('ID Token: $idToken');
      if (idToken == null) {
        print('ID Token is null');
        errorMessage.value = 'Google Sign-In gagal: ID Token tidak ditemukan.';
        isLoading.value = false;
        return;
      }

      print('Sending request to server...');
      final response = await http.post(
        Uri.parse('https://6fe0ea5b97fd.ngrok-free.app/api/auth/google/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken, 'role': 'admin'}),
      );
      print('Server Response: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        box.write('token', data['token']);
        box.write('user', data['user']);
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = data['message'] ?? 'Login Google gagal';
        print('Login failed: ${data['message']}');
      }
    } catch (e) {
      print('Error during Google Login: $e');
      errorMessage.value = 'Terjadi kesalahan saat login Google: $e';
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
