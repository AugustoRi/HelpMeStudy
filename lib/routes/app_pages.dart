import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/bindings/folder_binding.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';

import 'package:path_provider/path_provider.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.folder;

  static Future<String> getInitialPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
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
    ),
  ];
}


