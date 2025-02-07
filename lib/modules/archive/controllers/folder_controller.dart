import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/data/model/user_location.dart';
import 'package:path_provider/path_provider.dart';

class FolderController extends GetxController {
  var userLocations = <UserlocationModel>[].obs;
  final folderController = TextEditingController();
  var folders = <FileSystemEntity>[].obs;
  var itemCount = 0.obs;
  String nameOfFolder = "";

  @override
  void onInit() {
    super.onInit();
    getDir();
  }

  @override
  void onClose() {
    folderController.dispose();
    super.onClose();
  }

  void addUserLocation(String course) {
    userLocations.add(UserlocationModel(course: course));
    itemCount.value = userLocations.length;
    folderController.clear();
  }

  void removeUserLocation(int index) {
    if (index >= 0 && index < userLocations.length) {
      userLocations.removeAt(index);
      itemCount.value = userLocations.length;
    }
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<void> callFolderCreationMethod(String folderInAppDocDir) async {
    if (folderInAppDocDir.trim().isNotEmpty) {
      await createFolderInAppDocDir(folderInAppDocDir);
      getDir();
    }
  }

  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    folders.assignAll(dir.listSync(recursive: false, followLinks: false));
  }

  Future<FileStat> getFileType(FileSystemEntity file) {
    return file.stat();
  }

  bool isFile(FileSystemEntity entity) {
    return FileSystemEntity.isFileSync(entity.path);
  }
}