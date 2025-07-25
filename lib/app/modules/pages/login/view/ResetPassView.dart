// filepath: [ResetPassView.dart](http://_vscodecontentref_/0)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/auth_controller.dart';

class ResetPasswordView extends StatefulWidget {
  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final AuthController controller = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(labelText: 'Token (dari email)'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password baru'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Konfirmasi password baru'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.resetPassword(
                            email: emailController.text.trim(),
                            token: tokenController.text.trim(),
                            password: passwordController.text,
                            passwordConfirmation: confirmPasswordController.text,
                          );
                        },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text('Reset Password'),
                )),
          ],
        ),
      ),
    );
  }
}