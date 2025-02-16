import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:helpmestudy/routes/app_pages.dart';
import 'package:helpmestudy/services/auth_service.dart';

class UpdateController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();

  Future<void> updateUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    bool response = await authService.updateUser(usernameController.text, passwordController.text);

    if (response) {
      Get.snackbar('Success', 'Update successful');
      Get.offNamed(Routes.folder);
    } else {
      Get.snackbar('Error', 'Update failed');
      // print(response);
    }
  }
}