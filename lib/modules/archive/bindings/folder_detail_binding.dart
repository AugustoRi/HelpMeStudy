import 'package:get/get.dart';

import '../controllers/folder_detail_controller.dart';

class FolderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FolderDetailController>(
      () => FolderDetailController(),
    );
  }
}