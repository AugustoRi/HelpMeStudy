import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/bindings/folder_binding.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';
import 'package:helpmestudy/modules/auth/bindings/login_binding.dart';
import 'package:helpmestudy/modules/auth/bindings/signup_binding.dart';
import 'package:helpmestudy/modules/auth/views/login_view.dart';
import 'package:helpmestudy/modules/auth/views/signup_view.dart';
import 'package:helpmestudy/modules/auth/middleware/auth_middleware.dart';
import 'package:path_provider/path_provider.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static Future<String> getInitialPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.folder,
      page: () => FutureBuilder<String>(
        future: getInitialPath(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final folderController = Get.find<FolderController>();

            return FolderView(
              currentPath: snapshot.data!,
              onBack: () {
                folderController.getDir(snapshot.data!);
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      binding: FolderBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
