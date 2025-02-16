import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://172.24.176.1:8085';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<http.Response> get(BuildContext context, String endpoint) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _buildHeaders(token);

    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);

    if (response.statusCode == 401) {
      _handleUnauthorized(context);
    }

    return response;
  }

  Future<http.Response> post(BuildContext context, String endpoint, dynamic body) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = _buildHeaders(token);

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

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  void _handleUnauthorized(BuildContext context) async {
    await _storage.delete(key: 'jwt_token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
