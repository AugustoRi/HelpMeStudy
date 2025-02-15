import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Future<String> getInitialPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void onBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,  
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
              Get.to(() => HomePage());
            }
          },
        ),
        body: SafeArea(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.account_box_rounded,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Join us and start your journey!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Login!',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 50),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Register!',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
              ])),
        ));
  }
}
