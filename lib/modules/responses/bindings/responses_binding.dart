import 'package:get/get.dart';
import '../controllers/responses_controller.dart';

class ResponsesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResponsesController>(() => ResponsesController());
  }
}
