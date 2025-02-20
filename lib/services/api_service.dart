import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class HeaderStrategy {
  Map<String, String> buildHeaders(String? token);
}

class DefaultHeaderStrategy implements HeaderStrategy {
  @override
  Map<String, String> buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

class ApiService {
  final String baseUrl = 'http://172.24.176.1:8085';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final HeaderStrategy _headerStrategy;

  ApiService(this._headerStrategy);

  Future<http.Response> get(BuildContext context, String endpoint) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _headerStrategy.buildHeaders(token);

    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  Future<http.Response> post(BuildContext context, String endpoint, dynamic body) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _headerStrategy.buildHeaders(token);

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  Future<http.Response> put(BuildContext context, String endpoint, dynamic body) async {
    final token = await _storage.read(key: 'jwt_token');
    final userId = await _storage.read(key: 'userId');
    final headers = _headerStrategy.buildHeaders(token);

    if (userId == null) {
      throw Exception("User ID não encontrado no armazenamento seguro.");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint/$userId'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  Future<http.Response> putWithoutUserIdEnd(BuildContext context, String endpoint, dynamic body) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _headerStrategy.buildHeaders(token);

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  Future<http.Response> delete(BuildContext context, String endpoint) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _headerStrategy.buildHeaders(token);

    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  void _handleUnauthorized(BuildContext context) async {
    await _storage.delete(key: 'jwt_token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}