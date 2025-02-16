import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:helpmestudy/routes/app_pages.dart';
import 'package:helpmestudy/services/auth_service.dart';

class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    bool response = await authService.register(usernameController.text, passwordController.text);

    if (response) {
      Get.snackbar('Success', 'Registration successful');
      Get.offNamed(Routes.login);
    } else {
      Get.snackbar('Error', 'Registration failed');
    }
  }
}