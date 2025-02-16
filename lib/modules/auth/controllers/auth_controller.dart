import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'jwt_token');
    isAuthenticated.value = token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }
}