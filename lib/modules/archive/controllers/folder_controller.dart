import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderController extends GetxController {
  var folders = <FileSystemEntity>[].obs;
  final folderController = TextEditingController();
  var itemCount = 0.obs;
  String nameOfFolder = "";

  @override
  void onClose() {
    folderController.dispose();
    super.onClose();
  }

  Future<void> getDir(String path) async {
    final List<String> folderPaths = await compute(listDirectories, path);
    folders.assignAll(folderPaths.map((p) =>
        FileSystemEntity.typeSync(p) == FileSystemEntityType.directory
            ? Directory(p)
            : File(p)));
  }

  Future<String> createFolderInDir(String parentPath, String folderName) async {
    final Directory newFolder = Directory('$parentPath/$folderName/');
    if (await newFolder.exists()) {
      return newFolder.path;
    } else {
      final Directory createdFolder = await newFolder.create(recursive: true);
      return createdFolder.path;
    }
  }

  Future<void> callFolderCreationMethod(
      String parentPath, String folderName) async {
    if (folderName.trim().isNotEmpty) {
      await createFolderInDir(parentPath, folderName);
      await getDir(parentPath);
    }
  }

  bool isFile(FileSystemEntity entity) {
    return FileSystemEntity.isFileSync(entity.path);
  }

  Future<void> deleteFileOrDirectory(FileSystemEntity entity) async {
    try {
      if (entity is Directory) {
        await deleteDirectory(entity);
      } else if (entity is File) {
        await entity.delete();
      }
      print("Item deletado com sucesso.");
    } catch (e) {
      print("Erro ao excluir o item: $e");
    }
  }

  Future<void> deleteDirectory(Directory directory) async {
    try {
      if (directory.existsSync()) {
        final contents = directory.listSync();
        for (var entity in contents) {
          if (entity is Directory) {
            await deleteDirectory(entity);
          } else {
            await entity.delete();
          }
        }
        await directory.delete();
      }
    } catch (e) {
      print("Erro ao excluir o diretório: $e");
    }
  }

  Future<void> renameFileOrDirectory(
      FileSystemEntity entity, String newName) async {
    try {
      final parentPath = entity.parent.path;
      final newPath = '$parentPath/$newName';

      if (entity is Directory) {
        await entity.rename(newPath);
      } else if (entity is File) {
        await entity.rename(newPath);
      }
      print("Item renomeado com sucesso.");
    } catch (e) {
      print("Erro ao renomear o item: $e");
    }
  }

  Future<void> renameFolder(Directory folder, String newName) async {
    final String parentDirPath = folder.parent.path;
    final Directory newFolder = Directory('$parentDirPath/$newName');

    if (!newFolder.existsSync()) {
      await folder.rename(newFolder.path);
      getDir(parentDirPath); 
    }
  }

  Future<void> uploadFile(File file, String targetPath) async {
    try {
      String fileName = file.uri.pathSegments.last;

      String destinationPath = '$targetPath/$fileName';

      final destinationFile = File(destinationPath);
      if (await destinationFile.exists()) {
        print("O arquivo já existe no diretório de destino.");
      } else {
        await file.copy(destinationPath);
        print("Arquivo enviado com sucesso para $destinationPath");
      }

      await getDir(targetPath);
    } catch (e) {
      print("Erro ao fazer o upload do arquivo: $e");
    }
  }
}

List<String> listDirectories(String path) {
  final dir = Directory(path);
  return dir
      .listSync(recursive: false, followLinks: false)
      .map((e) => e.path)
      .toList();
}
