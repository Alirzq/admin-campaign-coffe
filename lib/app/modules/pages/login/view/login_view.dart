import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global-component/custom_button.dart';
import '../../../../global-component/input_field.dart';
import '../../../../../controller/login_controller.dart';
import '../../signup/view/signup_view.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
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
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      )
                    : SizedBox()),

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
                InputField(
                  controller: controller.usernameController,
                  hintText: 'Username',
                  filledColor: Color.fromARGB(255, 241, 244, 255),
                ),
                SizedBox(height: 16),
                InputField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  filledColor: Color.fromARGB(255, 241, 244, 255),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {}, // Tambahkan aksi lupa password
                    child: Text("Forgot your password?",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 31, 65, 187),
                        )),
                  ),
                ),

                // Login Button
                CustomButton(
                  text: 'Sign in',
                  onPressed: controller.login,
                  backgroundColor: Colors.blue.shade900,
                  textColor: Colors.white,
                ),
                SizedBox(height: 18),

                // Create Account
                GestureDetector(
                  onTap: () => Get.to(() => SignupView()),
                  child: Text("Create new account",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 73, 73, 73),
                      )),
                ),
                SizedBox(height: 60),

                // OR continue with
                Text("Or continue with",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    )),
                SizedBox(height: 16),

                // Google Login Button
                GestureDetector(
                  onTap: () {
                    // Tambahkan fungsi login dengan Google di sini
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
