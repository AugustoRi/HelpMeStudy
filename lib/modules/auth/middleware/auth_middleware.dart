import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/auth/controllers/auth_controller.dart';
import 'package:helpmestudy/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}