import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Dynamic Item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.courseTextEditingController,
              decoration: const InputDecoration(
                hintText: "Course",
                labelText: "Course",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                controller.addUserLocation(
                    controller.courseTextEditingController.text);
              },
              child: const Text("Add Folder"),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.itemCount.value,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title:
                            Text(controller.userLocations.value[index].course!),
                        trailing: GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red
                          ),
                          onTap: () {
                            controller.removeUserLocation(index);
                          },
                        ),
                      );
                    }),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
