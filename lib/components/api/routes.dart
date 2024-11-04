import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://localhost:8085';

Future<http.Response> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/users/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  return response;
}

Future<http.Response> register(String username, String password) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

  return response;
}

