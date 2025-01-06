import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:helpmestudy/data/model/user_location.dart';

class HomeController extends GetxController {
  Rx<List<UserlocationModel>> userLocations = Rx<List<UserlocationModel>>([]);

  TextEditingController courseTextEditingController = TextEditingController();
  late UserlocationModel userlocationModel;
  var itemCount = 0.obs;

  @override
  void onClose() {
    super.onClose();
    courseTextEditingController.dispose();
  }

  addUserLocation(String course) {
    userlocationModel = UserlocationModel(course: course);
    userLocations.value.add(userlocationModel);
    itemCount.value = userLocations.value.length;
    courseTextEditingController.clear();
  }

  removeUserLocation(int index) {
    userLocations.value.removeAt(index);
    itemCount.value = userLocations.value.length;
  }
}