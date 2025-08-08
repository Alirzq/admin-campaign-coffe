import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../global-component/widget/custom_button.dart';
import '../../../../global-component/widget/input_field.dart';
import '../../../../../controller/auth_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Reset Kata Sandi",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    )
                  : SizedBox()),
              InputField(
                controller: emailController,
                hintText: 'Email',
                filledColor: Color.fromARGB(255, 241, 244, 255),
              ),
              SizedBox(height: 16),
              InputField(
                controller: tokenController,
                hintText: 'Token (dari email)',
                filledColor: Color.fromARGB(255, 241, 244, 255),
              ),
              SizedBox(height: 16),
              InputField(
                controller: passwordController,
                hintText: 'Kata Sandi Baru',
                obscureText: true,
                filledColor: Color.fromARGB(255, 241, 244, 255),
              ),
              SizedBox(height: 16),
              InputField(
                controller: confirmPasswordController,
                hintText: 'Konfirmasi Kata Sandi',
                obscureText: true,
                filledColor: Color.fromARGB(255, 241, 244, 255),
              ),
              SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : CustomButton(
                      text: 'Reset Kata Sandi',
                      onPressed: () {
                        controller.resetPassword(
                          email: emailController.text.trim(),
                          token: tokenController.text.trim(),
                          password: passwordController.text.trim(),
                          passwordConfirmation: confirmPasswordController.text.trim(),
                        );
                      },
                      backgroundColor: Colors.blue.shade900,
                      textColor: Colors.white,
                    )),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: Text(
                  "Kembali ke Login",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}