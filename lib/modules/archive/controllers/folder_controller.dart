import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/data/model/user_location.dart';
import 'package:path_provider/path_provider.dart';

class FolderController extends GetxController {
  Rx<List<UserlocationModel>> userLocations = Rx<List<UserlocationModel>>([]);

  final folderController = TextEditingController();
  late String nameOfFolder;
  late List<FileSystemEntity> folders = [];
  late UserlocationModel userlocationModel;
  var itemCount = 0.obs;

  @override
  void onInit() {
    getDir();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    folderController.dispose();
  }

  addUserLocation(String course) {
    userlocationModel = UserlocationModel(course: course);
    userLocations.value.add(userlocationModel);
    itemCount.value = userLocations.value.length;
    folderController.clear();
  }

  removeUserLocation(int index) {
    userLocations.value.removeAt(index);
    itemCount.value = userLocations.value.length;
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  callFolderCreationMethod(String folderInAppDocDir) async {
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    if (kDebugMode) {
      print(actualFileName);
    }
  }

  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    folders = myDir.listSync(recursive: true, followLinks: false);
    if (kDebugMode) {
      print(folders);
    }
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'ADD FOLDER',
                textAlign: TextAlign.left,
              ),
              Text(
                'Type a folder name to add',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: folderController,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Enter folder name'),
                onChanged: (val) {
                  setState(() {
                    nameOfFolder = folderController.text;
                    if (kDebugMode) {
                      print(nameOfFolder);
                    }
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (nameOfFolder != null) {
                  await callFolderCreationMethod(nameOfFolder);
                  getDir();
                  folderController.clear();
                  nameOfFolder = "";
                  Navigator.of(context).pop();
                }
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure to delete this folder?',
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('Yes'),
              onPressed: () async {
                await folders[index].delete();
                getDir();
                Navigator.of(context).pop();
              },
            ),
            FloatingActionButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getFileType(file) {
    return file.stat();
  }
}
