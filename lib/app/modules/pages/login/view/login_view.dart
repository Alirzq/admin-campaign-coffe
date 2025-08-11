import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global-component/widget/custom_button.dart';
import '../../../../global-component/widget/input_field.dart';
import '../../../../../controller/auth_controller.dart';
import '../../signup/view/signup_view.dart';
import 'ResetPassView.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // Pantau errorMessage untuk menampilkan dialog verifikasi email
    ever(controller.errorMessage, (String message) {
      if (message.contains('Email belum diverifikasi')) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Verifikasi Email Diperlukan'),
              content: Text(
                  'Email Anda belum diverifikasi. Apakah Anda ingin mengirim ulang link verifikasi?'),
              actions: [
                TextButton(
                  child: Text('Batal'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Kirim Ulang'),
                  onPressed: () {
                    controller.resendVerificationEmail(
                        controller.emailController.text.trim());
                    Navigator.of(context).pop();
                    Get.snackbar(
                        'Sukses', 'Link verifikasi telah dikirim ulang.');
                  },
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),

                // Error Message
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      )
                    : SizedBox()),

                // Title
                Text(
                  "Login here",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Welcome text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Text(
                      "Welcome back you’ve been missed!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 100),

                // Username Field
                InputField(
                  controller: controller.emailController,
                  hintText: 'email',
                  filledColor: Color.fromARGB(255, 241, 244, 255),
                ),
                SizedBox(height: 16),

                // Password Field
                InputField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  filledColor: Color.fromARGB(255, 241, 244, 255),
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Dialog input email untuk reset password
                      final TextEditingController emailResetController =
                          TextEditingController();
                      String? errorText;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 16,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header Section
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                      255, 31, 65, 187)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.lock_reset_rounded,
                                              color: const Color.fromARGB(
                                                  255, 31, 65, 187),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Reset Password',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'We\'ll send you a reset link',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: Colors.grey.shade400,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              minimumSize: const Size(36, 36),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Email Input Section
                                      Text(
                                        'Email Address',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: emailResetController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Enter your email address',
                                            hintStyle: GoogleFonts.poppins(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                            ),
                                            errorText: errorText,
                                            errorStyle: GoogleFonts.poppins(
                                              color: Colors.red.shade600,
                                              fontSize: 12,
                                            ),
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(12),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 31, 65, 187)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.email_outlined,
                                                color: const Color.fromARGB(
                                                    255, 31, 65, 187),
                                                size: 20,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade200),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade200),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 31, 65, 187),
                                                width: 2,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: Colors.red.shade300),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  color: Colors.red.shade400,
                                                  width: 2),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                          ),
                                          cursorColor: const Color.fromARGB(
                                              255, 31, 65, 187),
                                          onChanged: (value) {
                                            if (errorText != null) {
                                              setState(() {
                                                errorText = null;
                                              });
                                            }
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Action Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                backgroundColor:
                                                    Colors.grey.shade50,
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            flex: 2,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final email =
                                                    emailResetController.text
                                                        .trim();
                                                if (email.isEmpty) {
                                                  setState(() {
                                                    errorText =
                                                        'Email harus diisi';
                                                  });
                                                } else if (!RegExp(
                                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                    .hasMatch(email)) {
                                                  setState(() {
                                                    errorText =
                                                        'Format email tidak valid';
                                                  });
                                                } else {
                                                  // Show loading
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        Center(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const CircularProgressIndicator(),
                                                            const SizedBox(
                                                                height: 16),
                                                            Text(
                                                              'Sending reset link...',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );

                                                  controller
                                                      .forgotPassword(email);

                                                  // Close loading after 2 seconds
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    Navigator.of(context)
                                                        .pop(); // Close loading
                                                    Navigator.of(context)
                                                        .pop(); // Close dialog

                                                    // Show success message
                                                    Get.snackbar(
                                                      'Email Sent!',
                                                      'Password reset link has been sent to your email',
                                                      backgroundColor:
                                                          Colors.green.shade100,
                                                      colorText:
                                                          Colors.green.shade800,
                                                      duration: const Duration(
                                                          seconds: 3),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              16),
                                                      borderRadius: 12,
                                                      icon: Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors
                                                            .green.shade600,
                                                      ),
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                    );
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 31, 65, 187),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 2,
                                                shadowColor:
                                                    const Color.fromARGB(
                                                            255, 31, 65, 187)
                                                        .withOpacity(0.3),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.send_rounded,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Send Reset Link',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // Info Text
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.blue.shade100),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.blue.shade600,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Check your spam folder if you don\'t receive the email',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(),
                      child: Text(
                        "Forgot your password?",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 31, 65, 187),
                        ),
                      ),
                    ),
                  ),
                ),
                // Sign In Button with Loading
                Obx(() => CustomButton(
                      text:
                          controller.isLoading.value ? 'Loading...' : 'Sign in',
                      onPressed: () {
                        if (!controller.isLoading.value) {
                          controller.login();
                        }
                      },
                      backgroundColor: Colors.blue.shade900,
                      textColor: Colors.white,
                    )),

                SizedBox(height: 18),

                // Create Account
                GestureDetector(
                  onTap: () => Get.to(() => SignupView()),
                  child: Text(
                    "Create new account",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 73, 73, 73),
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // OR
                Text(
                  "Or continue with",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 16),

                // Google Login Button
                GestureDetector(
                  onTap: () {
                    controller.loginWithGoogle();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 236, 236, 236),
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      "https://img.icons8.com/win10/512/google-logo.png",
                      width: 60,
                      height: 30,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
