import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/auth/views/update_view.dart';

class FolderView extends GetView<FolderController> {
  final String currentPath;
  final Function onBack;

  const FolderView(
    {super.key, required this.currentPath, required this.onBack}
  );

  @override
  Widget build(BuildContext context) {
    controller.getDir(currentPath);

    return WillPopScope(
      onWillPop: () async {
        onBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentPath.split('/').last),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showMyDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => _uploadFile(),
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
                                ? const Icon(Icons.file_copy_outlined,
                                    size: 100, color: Colors.orange)
                                : InkWell(
                                    onTap: () {
                                      String newPath =
                                          '$currentPath/${folder.path.split('/').last}';
                                      Get.to(() => FolderView(
                                            currentPath: newPath,
                                            onBack: onBack,
                                          ));
                                    },
                                    child: const Icon(Icons.folder,
                                        size: 100, color: Colors.orange),
                                  ),
                            Text(folder.path.split('/').last),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => showRenameDialog(context, index),
                              child: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => showDeleteDialog(context, index),
                              child:
                                  const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Tela Inicial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
          ],
          onTap: (int index) {
            if (index == 0) {
              Get.to(
                  () => FolderView(currentPath: currentPath, onBack: onBack));
            } else if (index == 1) {
              Get.to(() => UpdateView());
            }
          },
        ),
      ),
    );
  }

  Future<void> showRenameDialog(BuildContext context, int index) async {
    if (index < 0 || index >= controller.folders.length) return;
    final folder = controller.folders[index];

    final TextEditingController renameController =
        TextEditingController(text: folder.path.split('/').last);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Item'),
          content: TextField(
            controller: renameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new item name'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child:
                  const Text('Rename', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final newName = renameController.text.trim();
                if (newName.isNotEmpty) {
                  await controller.renameFileOrDirectory(folder, newName);
                  await controller.getDir(currentPath); // Atualize a lista
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ADD FOLDER'),
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
                  await controller.callFolderCreationMethod(
                      currentPath, controller.nameOfFolder);
                  controller.getDir(currentPath);
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
    final folder = controller.folders[index];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await controller.deleteFileOrDirectory(
                    folder);
                await controller.getDir(currentPath);
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

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      await controller.uploadFile(file, currentPath);

      await controller.getDir(currentPath);
    } else {
      print("Nenhum arquivo selecionado.");
    }
  }
}
