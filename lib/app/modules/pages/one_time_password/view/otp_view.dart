import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global-component/widget/custom_button.dart';
import '../../../../global-component/widget/warning_massage.dart';
import '../../../../../controller/otp_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpView extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "OTP verification code",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 24),
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? WarningMessage(message: controller.errorMessage.value)
                : SizedBox()),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 50,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade900),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: controller.otpControllers[index],
                      focusNode: controller.focusNodes[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        controller.onOtpChange(value, index);
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Confirm',
              onPressed: controller.verifyOtp,
              backgroundColor: Colors.blue.shade900,
              textColor: Colors.white,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: controller.resendOtp,
              child: Text(
                "Resend OTP verification code",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
