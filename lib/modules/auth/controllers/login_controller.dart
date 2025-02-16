import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/routes/app_pages.dart';
import 'package:helpmestudy/services/auth_service.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  var isLoading = false.obs;

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    bool response = await authService.login(usernameController.text, passwordController.text);

    isLoading.value = false;

    if (response) {
      Get.snackbar("Success", "Login successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      Get.offNamed(Routes.folder);
    } else {
      Get.snackbar("Error", "Login failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
