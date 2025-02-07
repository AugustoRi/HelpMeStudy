
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_detail_view.dart';

class FolderView extends GetView<FolderController> {
  const FolderView({super.key});

    Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Text('ADD FOLDER', textAlign: TextAlign.left),
              Text('Type a folder name to add', style: TextStyle(fontSize: 14)),
            ],
          ),
          content: TextField(
            controller: controller.folderController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter folder name'),
            onChanged: (val) => controller.nameOfFolder = val,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (controller.nameOfFolder.trim().isNotEmpty) {
                  await controller.callFolderCreationMethod(controller.nameOfFolder);
                  controller.folderController.clear();
                  controller.nameOfFolder = "";
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(BuildContext context, int index) async {
    if (index < 0 || index >= controller.folders.length) return;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure to delete this folder?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await controller.folders[index].delete();
                controller.getDir();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Folder Info"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showMyDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: controller.folders.length,
            itemBuilder: (context, index) {
              final folder = controller.folders[index];
              final isFile = controller.isFile(folder);

              return Material(
                elevation: 6.0,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isFile
                              ? const Icon(Icons.file_copy_outlined, size: 100, color: Colors.orange)
                              : InkWell(
                                  onTap: () {
                                    Get.to(() => FolderDetailView(filesPath: folder.path));
                                  },
                                  child: const Icon(Icons.folder, size: 100, color: Colors.orange),
                                ),
                          Text(folder.path.split('/').last),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => showDeleteDialog(context, index),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
