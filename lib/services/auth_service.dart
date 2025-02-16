import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final String baseUrl = 'http://172.24.176.1:8085';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await _saveToken(data['token']);
        await _saveUserId(data['token']);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'username': username, 'password': password, 'role': 'USER'}),
    );

    return response.statusCode == 200;
  }

  Future<bool> updateUser(String username, String password) async {
    String? userId = await _storage.read(key: 'userId');

    if (userId == null) {
      throw Exception("User ID não encontrado no armazenamento seguro.");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/users/auth/update/$userId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}'
      },
      body: jsonEncode({'username': username, 'password': password, 'role': 'USER'}),
    );

    return response.statusCode == 200;
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'userId');
  }

  Future<void> _saveUserId(String token) async {
    try {
      final jwt = JWT.decode(token);
      if (jwt.payload.containsKey('userId')) {
        await _storage.write(key: 'user_id', value: jwt.payload['userId'].toString());
      } else {
        throw Exception("O token JWT não contém um 'userId'.");
      }
    } catch (e) {
      throw Exception("Erro ao decodificar o token JWT: $e");
    }
  }
}
