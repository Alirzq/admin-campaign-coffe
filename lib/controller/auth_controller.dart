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
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await http
          .post(
        Uri.parse('https://96057b35e6b9.ngrok-free.app/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
        print('Parsed Data: $data');
      } catch (e) {
        print('JSON Decode Error: $e');
        errorMessage.value =
            'Terjadi kesalahan dalam memproses data dari server.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      
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
        // Handle different error cases based on status code and response
        String errorMsg = _getLoginErrorMessage(response.statusCode, data);
        errorMessage.value = errorMsg;

        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error during login: $e');

      // Handle specific error types
      if (e.toString().contains('timeout')) {
        errorMessage.value =
            'Koneksi ke server gagal. Silakan cek internet Anda.';
      } else if (e.toString().contains('FormatException') ||
          e.toString().contains('JSON')) {
        errorMessage.value =
            'Terjadi kesalahan dalam memproses data dari server.';
      } else if (e.toString().contains('subtype') ||
          e.toString().contains('type') ||
          e.toString().contains('cast')) {
        errorMessage.value =
            'Terjadi kesalahan dalam memproses respons server.';
      } else {
        errorMessage.value =
            'Terjadi kesalahan tak terduga. Silakan coba lagi.';
      }

      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  String _getLoginErrorMessage(int statusCode, Map<String, dynamic> data) {
    print('Processing error for status: $statusCode, data: $data');

    String apiMessage = '';

    try {
      // Handle the actual API response structure safely
      if (data.containsKey('message') && data['message'] != null) {
        var messageObj = data['message'];
        print('Message object type: ${messageObj.runtimeType}');
        print('Message object: $messageObj');

        if (messageObj is Map<String, dynamic>) {
          // Check if it's a direct message: {"message": {"message": "Password salah."}}
          if (messageObj.containsKey('message') &&
              messageObj['message'] is String) {
            apiMessage = messageObj['message'].toString();
            print('Found direct message: $apiMessage');
          }
          // Check if it's validation errors: {"message": {"errors": {...}}}
          else if (messageObj.containsKey('errors') &&
              messageObj['errors'] is Map) {
            Map<String, dynamic> errors =
                messageObj['errors'] as Map<String, dynamic>;
            List<String> errorMessages = [];

            errors.forEach((key, value) {
              if (value is List) {
                for (var item in value) {
                  if (item is String) {
                    errorMessages.add(item);
                  }
                }
              }
            });

            if (errorMessages.isNotEmpty) {
              apiMessage = errorMessages.join(', ');
              print('Found validation errors: $apiMessage');
            }
          }
        } else if (messageObj is String) {
          apiMessage = messageObj;
          print('Found string message: $apiMessage');
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
      // Continue with fallback handling
    }

    print('Final API message: $apiMessage');

    // Handle specific status codes
    switch (statusCode) {
      case 401:
        // Unauthorized - wrong credentials
        if (apiMessage.toLowerCase().contains('password') ||
            apiMessage.toLowerCase().contains('kata sandi') ||
            apiMessage.toLowerCase().contains('salah')) {
          return 'Kata sandi yang Anda masukkan salah.';
        } else if (apiMessage.toLowerCase().contains('email')) {
          return 'Email yang Anda masukkan tidak terdaftar.';
        } else if (apiMessage.toLowerCase().contains('credential')) {
          return 'Email atau kata sandi yang Anda masukkan salah.';
        } else {
          return apiMessage.isNotEmpty
              ? apiMessage
              : 'Email atau kata sandi yang Anda masukkan salah.';
        }

      case 422:
        // Validation error - already handled above in the parsing section
        return apiMessage.isNotEmpty
            ? apiMessage
            : 'Data yang Anda masukkan tidak valid.';

      case 429:
        // Too many requests
        return 'Terlalu banyak percobaan login. Silakan coba beberapa saat lagi.';

      case 500:
        // Server error
        return 'Terjadi kesalahan pada server. Silakan coba beberapa saat lagi.';

      case 503:
        // Service unavailable
        return 'Layanan sedang dalam pemeliharaan. Silakan coba beberapa saat lagi.';

      default:
        // Use API message if available, otherwise generic message
        if (apiMessage.isNotEmpty) {
          return apiMessage;
        } else {
          return 'Login gagal. Silakan periksa email dan kata sandi Anda.';
        }
    }
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    Get.snackbar('Sukses', 'Anda telah logout.',
        backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAllNamed('/login');
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Mohon masukkan email Anda.';
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
        Uri.parse('https://96057b35e6b9.ngrok-free.app/api/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
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
        errorMessage.value =
            data['data']['message'] ?? 'Gagal mengirim link reset kata sandi.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mengirim link reset. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
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
    if (email.isEmpty ||
        token.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty) {
      errorMessage.value = 'Mohon isi semua kolom dengan lengkap.';
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (password != passwordConfirmation) {
      errorMessage.value = 'Kata sandi dan konfirmasi kata sandi tidak cocok.';
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
        Uri.parse('https://96057b35e6b9.ngrok-free.app/api/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          data['data']['message'] ??
              'Kata sandi berhasil direset. Silakan login dengan kata sandi baru.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      } else {
        errorMessage.value = data['data']['message'] ??
            'Gagal mereset kata sandi. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mereset kata sandi. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during reset password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Mohon masukkan email Anda.';
      Get.snackbar('Peringatan', errorMessage.value,
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
        Uri.parse('https://96057b35e6b9.ngrok-free.app/api/email/resend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          data['data']['message'] ??
              'Link verifikasi baru telah dikirim ke email Anda.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = data['data']['message'] ??
            'Gagal mengirim link verifikasi. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mengirim link verifikasi. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
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
        Get.snackbar('Peringatan', errorMessage.value,
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      print('Google Sign-In successful, getting authentication...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      print('ID Token: $idToken');
      if (idToken == null) {
        print('ID Token is null');
        errorMessage.value = 'Gagal login dengan Google. Silakan coba lagi.';
        isLoading.value = false;
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      print('Sending request to server...');
      final response = await http
          .post(
        Uri.parse('https://96057b35e6b9.ngrok-free.app/api/auth/google/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      print('Server Response: ${response.statusCode} - ${response.body}');
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        box.write('token', data['data']['token']);
        box.write('user', data['data']['user']);
        Get.snackbar(
          'Sukses',
          data['data']['message'] ??
              'Login dengan Google berhasil! Selamat datang.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = data['data']['message'] ??
            'Gagal login dengan Google. Silakan coba lagi.';
        Get.snackbar('Gagal', errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        print('Login failed: ${data['data']['message']}');
      }
    } catch (e) {
      print('Error during Google Login: $e');
      errorMessage.value = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat login dengan Google. Silakan coba lagi.';
      Get.snackbar('Gagal', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
