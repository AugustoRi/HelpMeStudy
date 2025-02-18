import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIIntegrationService {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';
  static final String _model = dotenv.env['MODEL'] ?? '';

  Future<String?> fetchCompletion(List<Map<String, dynamic>> prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseBody = jsonDecode(decodedBody);
        print("Resposta da API: $responseBody");

        if (responseBody.containsKey('choices') &&
            responseBody['choices'] is List &&
            responseBody['choices'].isNotEmpty &&
            responseBody['choices'][0].containsKey('message') &&
            responseBody['choices'][0]['message'].containsKey('content')) {
          
          String content = responseBody['choices'][0]['message']['content'];

          String decodedContent = utf8.decode(utf8.encode(content)); 

          return decodedContent;
        } else {
          print("Erro: Estrutura da resposta inesperada.");
          return null;
        }
      } else {
        print('Erro: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exceção ocorreu: $e');
      return null;
    }
  }
}
