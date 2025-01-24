import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/bindings/folder_binding.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';

import 'package:helpmestudy/modules/archive/bindings/folder_detail_binding.dart';
import 'package:helpmestudy/modules/archive/views/folder_detail_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.folder;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.folder,
      page: () => const FolderView(),
      binding: FolderBinding(),
    ),
  ];
}