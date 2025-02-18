import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';
import 'package:helpmestudy/modules/auth/views/update_view.dart';
import 'package:helpmestudy/modules/responses/controllers/responses_controller.dart';
import 'package:path_provider/path_provider.dart';

class ResponsesView extends GetView<ResponsesController> {
  const ResponsesView({super.key});

  static Future<String> getInitialPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResponsesController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchResponses();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Respostas"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.responses.length,
          itemBuilder: (context, index) {
            final response = controller.responses[index];
            return ListTile(
              title: Text(response['content'] ?? 'Sem conteúdo'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showUpdateDialog(context, response['id'], response['content']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteResponse(response['id']);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Respostas Geradas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Get.to(() => FutureBuilder<String>(
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
                }));
          } else if (index == 1) {
            Get.to(() => ResponsesView());
          } else if (index == 2) {
            Get.to(() => UpdateView());
          }
        },
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int id, String currentContent) {
    final TextEditingController contentController = TextEditingController(text: currentContent);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Atualizar Resposta"),
          content: TextField(
            controller: contentController,
            decoration: InputDecoration(hintText: "Digite a nova resposta"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.updateResponse(id, contentController.text);
                Navigator.pop(context);
              },
              child: Text("Atualizar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
