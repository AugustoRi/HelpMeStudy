import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/folder_detail_controller.dart';

class FolderDetailView extends StatelessWidget {
  final String filesPath;

  const FolderDetailView({super.key, required this.filesPath});

  @override
  Widget build(BuildContext context) {
    final FolderDetailController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddFolderDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final file = controller.folders[index];

            return Material(
              elevation: 6.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<FileStat>(
                          future: controller.getFileType(file),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.data?.type == FileSystemEntityType.file) {
                                return Icon(Icons.file_copy_outlined, size: 100, color: Colors.orange);
                              } else {
                                return InkWell(
                                  onTap: () {
                                    controller.getDir(file.path);
                                  },
                                  child: Icon(Icons.folder, size: 100, color: Colors.orange),
                                );
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Text(file.path.split('/').last),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        _showDeleteDialog(context, index);
                      },
                      child: Icon(Icons.delete, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: controller.folders.length,
        );
      }),
    );
  }

  Future<void> showAddFolderDialog(BuildContext context) async {
    final FolderDetailController controller = Get.find();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('ADD FOLDER'),
              Text('Type a folder name to add', style: TextStyle(fontSize: 14)),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: controller.folderDetailController,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Enter folder name'),
                onChanged: (val) {
                  controller.updateFolderName(val);
                },
              );
            },
          ),
          actions: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (controller.folderName.value.isNotEmpty) {
                  await controller.callFolderCreationMethod(controller.folderName.value);
                  controller.folderDetailController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int index) async {
    final FolderDetailController controller = Get.find();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to delete this folder?'),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('Yes'),
              onPressed: () async {
                await controller.folders[index].delete();
                controller.getDir(filesPath);
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
}
