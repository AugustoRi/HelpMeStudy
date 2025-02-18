import 'package:get/get.dart';
import 'package:helpmestudy/services/responses_service.dart';

class ResponsesController extends GetxController {
  var responses = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final responseService = Get.put(ResponseService());

  @override
  void onInit() {
    super.onInit();
    fetchResponses();
  }

  Future<void> fetchResponses() async {
    isLoading(true);
    try {
      final data = await responseService.fetchResponses(Get.context!);
      if (data != null) {
        responses.assignAll(data);
      }
    } catch (e) {
      Get.snackbar("Erro", "Falha ao carregar respostas.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addResponse(String content) async {
    isLoading(true);
    try {
      bool success = await responseService.saveResponse(Get.context!, content);
      if (success) {
        fetchResponses();
        Get.snackbar("Sucesso", "Resposta adicionada!");
      } else {
        Get.snackbar("Erro", "Não foi possível salvar a resposta.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Ocorreu um erro ao adicionar a resposta.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateResponse(int id, String newContent) async {
    isLoading(true);
    try {
      bool success = await responseService.updateResponse(Get.context!, id, newContent);
      if (success) {
        fetchResponses();
        Get.snackbar("Sucesso", "Resposta atualizada!");
      } else {
        Get.snackbar("Erro", "Não foi possível atualizar a resposta.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Erro ao atualizar a resposta.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteResponse(int id) async {
    isLoading(true);
    try {
      bool success = await responseService.deleteResponse(Get.context!, id);
      if (success) {
        responses.removeWhere((response) => response['id'] == id);
        Get.snackbar("Sucesso", "Resposta deletada!");
      } else {
        Get.snackbar("Erro", "Não foi possível deletar a resposta.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Erro ao deletar a resposta.");
    } finally {
      isLoading(false);
    }
  }
}
