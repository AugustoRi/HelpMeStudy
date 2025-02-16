import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/auth/controllers/auth_controller.dart';
import 'package:helpmestudy/routes/app_pages.dart';

void main() {
  Get.put(AuthController());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}