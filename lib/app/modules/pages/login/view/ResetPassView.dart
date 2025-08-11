import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global-component/widget/custom_button.dart';
import '../../../../global-component/widget/input_field.dart';
import '../../../../../controller/auth_controller.dart';
import 'package:flutter/services.dart';

class ResetPasswordView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Header Section with Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 60,
                    color: Colors.blue.shade900,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Reset Kata Sandi",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Masukkan kode verifikasi yang telah dikirim ke email Anda",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                // Error Message
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: GoogleFonts.poppins(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()),

                // Email Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: emailController,
                      hintText: 'Masukkan email Anda',
                      filledColor: const Color.fromARGB(255, 241, 244, 255),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Token Input - Numbers Only
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Kode Verifikasi',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Text(
                            'Hanya Angka',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: tokenController,
                      hintText: 'Contoh: 123456',
                      filledColor: const Color.fromARGB(255, 241, 244, 255),
                      numbersOnly: true,
                      maxLength: 6, // Assuming 6-digit token
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kode 6 digit yang dikirim ke email Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // New Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kata Sandi Baru',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: passwordController,
                      hintText: 'Masukkan kata sandi baru',
                      obscureText: true,
                      filledColor: const Color.fromARGB(255, 241, 244, 255),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Confirm Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konfirmasi Kata Sandi',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: confirmPasswordController,
                      hintText: 'Ulangi kata sandi baru',
                      obscureText: true,
                      filledColor: const Color.fromARGB(255, 241, 244, 255),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Reset Button
                Obx(() => controller.isLoading.value
                    ? Container(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade900),
                          ),
                        ),
                      )
                    : CustomButton(
                        text: 'Reset Kata Sandi',
                        onPressed: () {
                          // Validate inputs before sending
                          if (emailController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Peringatan',
                              'Mohon masukkan email Anda',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                            return;
                          }

                          if (tokenController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Peringatan',
                              'Mohon masukkan kode verifikasi',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                            return;
                          }

                          if (tokenController.text.trim().length != 6) {
                            Get.snackbar(
                              'Peringatan',
                              'Kode verifikasi harus 6 digit',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                            return;
                          }

                          if (passwordController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Peringatan',
                              'Mohon masukkan kata sandi baru',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                            return;
                          }

                          if (passwordController.text.trim() !=
                              confirmPasswordController.text.trim()) {
                            Get.snackbar(
                              'Peringatan',
                              'Konfirmasi kata sandi tidak cocok',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                            return;
                          }

                          controller.resetPassword(
                            email: emailController.text.trim(),
                            token: tokenController.text.trim(),
                            password: passwordController.text.trim(),
                            passwordConfirmation:
                                confirmPasswordController.text.trim(),
                          );
                        },
                        backgroundColor: Colors.blue.shade900,
                        textColor: Colors.white,
                      )),

                const SizedBox(height: 20),

                // Back to Login Button
                TextButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: Colors.blue.shade900,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Kembali ke Login",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Resend Code Option
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak menerima kode verifikasi?',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          if (emailController.text.trim().isNotEmpty) {
                            controller
                                .forgotPassword(emailController.text.trim());
                          } else {
                            Get.snackbar(
                              'Peringatan',
                              'Mohon masukkan email terlebih dahulu',
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade800,
                            );
                          }
                        },
                        child: Text(
                          'Kirim Ulang Kode',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
