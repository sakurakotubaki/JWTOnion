import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract interface class JwtRepository {
  Future<String?> jwtLogin(String username, String password);

}
final jwtRepositoryImplProvider = Provider<JwtRepositoryImpl>((ref) => JwtRepositoryImpl());

class JwtRepositoryImpl implements JwtRepository {

  @override
  Future<String?> jwtLogin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token'] as String);
          return 'success';
        } else if (responseData['error'] != null) {
          return responseData['error'];
        } else {
          return 'Login Error: Unexpected response';
        }
      } else {
        return 'HTTP Error with code: ${response.statusCode}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}
