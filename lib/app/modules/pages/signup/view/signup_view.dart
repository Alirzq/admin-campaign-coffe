import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global-component/widget/custom_button.dart';
import '../../../../global-component/widget/input_field.dart';
import '../../../../global-component/widget/warning_massage.dart';
import '../../../../../controller/signup_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupView extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Create an account so you can explore all the existing jobs",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),

            Obx(() => controller.errorMessage.value.isNotEmpty
                ? WarningMessage(message: controller.errorMessage.value)
                : SizedBox()),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                children: [
                  InputField(
                    controller: controller.usernameController,
                    hintText: 'Username',
                    filledColor: const Color.fromARGB(255, 241, 244, 255),
                  ),
                  SizedBox(height: 25),
                  InputField(
                    controller: controller.emailController,
                    hintText: 'Email',
                    filledColor: Color.fromARGB(255, 241, 244, 255),
                  ),
                  SizedBox(height: 25),
                  InputField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    filledColor: Color.fromARGB(255, 241, 244, 255),
                  ),
                  SizedBox(height: 25),
                  InputField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    filledColor: Color.fromARGB(255, 241, 244, 255),
                  ),
                  SizedBox(height: 25),
                  InputField(
                    controller: controller.phoneController,
                    hintText: 'Phone Number',
                    filledColor: Color.fromARGB(255, 241, 244, 255),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            // Next Button
            CustomButton(
              text: 'Next',
              onPressed: controller.signUp,
              backgroundColor: Colors.blue.shade900,
              textColor: Colors.white,
            ),
            SizedBox(height: 16),

            // Already have an account
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                "Already have an account",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
