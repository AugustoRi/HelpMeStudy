import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FolderDetailController extends GetxController {
  RxList<FileSystemEntity> folders = <FileSystemEntity>[].obs;
  RxString folderName = ''.obs;
  TextEditingController folderDetailController = TextEditingController();

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

  Future<void> getDir(String path) async {
    final myDir = Directory(path);
    folders.value = myDir.listSync(recursive: true, followLinks: false);
  }

  Future<void> callFolderCreationMethod(String folderInAppDocDir) async {
    await createFolderInAppDocDir(folderInAppDocDir);
    getDir(folderInAppDocDir);
  }

  Future<FileStat> getFileType(FileSystemEntity file) async {
    return await file.stat();
  }

  void updateFolderName(String name) {
    folderName.value = name;
  }

  @override
  void onInit() {
    super.onInit();
    getDir(''); // Initialize the folder list on controller initialization
  }
}