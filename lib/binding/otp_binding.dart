import 'package:get/get.dart';
import '../controller/otp_controller.dart'; // Import controller untuk OTP

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController()); // Mengatur OtpController
  }
}
