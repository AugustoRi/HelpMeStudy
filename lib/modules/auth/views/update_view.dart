import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/components/auth/button.dart';
import 'package:helpmestudy/components/auth/textfield.dart';
import 'package:helpmestudy/modules/archive/controllers/folder_controller.dart';
import 'package:helpmestudy/modules/archive/views/folder_view.dart';
import 'package:helpmestudy/modules/auth/controllers/update_controller.dart';
import 'package:helpmestudy/routes/app_pages.dart';
import 'package:helpmestudy/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';


class UpdateView extends GetView<UpdateController> {
  const UpdateView({super.key});

  static Future<String> getInitialPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
              Get.to(() => UpdateView());
            }
          },
        ),
      body: SafeArea(
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.account_box_rounded, size: 100),
                const SizedBox(height: 50),
                Text(
                  'Edit your profile',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                AuthTextFieldComponent(
                  controller: Get.put(UpdateController()).usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                AuthTextFieldComponent(
                  controller: Get.put(UpdateController()).passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                AuthTextFieldComponent(
                  controller: Get.put(UpdateController()).confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                ButtonAuthComponent(onTap: Get.put(UpdateController()).updateUser, label: "Update",),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Are you sure you want to leave?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        await Get.put(AuthService()).logout();
                        Get.toNamed(Routes.login);
                      },
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
