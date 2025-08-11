import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/auth_controller.dart';

class EmailVerificationView extends StatelessWidget {
  final String email;
  final AuthController controller = Get.find<AuthController>();

  EmailVerificationView({required this.email});

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
                "Verifikasi Email",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Kami telah mengirimkan link verifikasi ke $email. Silakan cek email Anda dan klik link untuk memverifikasi akun.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16),
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
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.resendVerificationEmail(email);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Kirim Ulang Link Verifikasi",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
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