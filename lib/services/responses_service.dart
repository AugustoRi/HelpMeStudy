import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class ResponseService {
  final ApiService apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>?> fetchResponses(BuildContext context) async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception("User ID não encontrado.");
    }

    final response = await apiService.get(context, "api/users/$userId/responses");

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> saveResponse(BuildContext context, String content) async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception("User ID não encontrado.");
    }

    final response = await apiService.post(context, "api/users/$userId/responses", jsonEncode({
      "content": content,
    }));

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getResponseById(BuildContext context, int responseId) async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception("User ID não encontrado.");
    }

    final response = await apiService.get(context, "api/users/$userId/responses/$responseId");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> updateResponse(BuildContext context, int responseId, String newContent) async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception("User ID não encontrado.");
    }

    final response = await apiService.putWithoutUserIdEnd(context, "api/users/$userId/responses/$responseId", jsonEncode({
      "content": newContent,
    }));

    return response.statusCode == 200;
  }

  Future<bool> deleteResponse(BuildContext context, int responseId) async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      throw Exception("User ID não encontrado.");
    }

    final response = await apiService.delete(context, "api/users/$userId/responses/$responseId");
    return response.statusCode == 204;
  }
}
