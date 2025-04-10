import 'package:get/get.dart';
import '../controller/signup_controller.dart'; // Import controller untuk Signup

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
        () => SignupController()); // Mengatur SignupController
  }
}
