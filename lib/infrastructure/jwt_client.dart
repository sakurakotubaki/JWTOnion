import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_auth/core/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// JWT認証のロジックを定義するインターフェース
abstract interface class JwtRepository {
  Future<String?> jwtLogin(String username, String password);
  Future<String?> jwtRegister(String username, String password);
  Future<void> logOut();
}

final jwtRepositoryImplProvider =
    Provider<JwtRepositoryImpl>((ref) => JwtRepositoryImpl());

// JWT認証のロジックを実装したクラス
class JwtRepositoryImpl implements JwtRepository {
  // JWTログインをするメソッド
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

  // JWT認証の新規登録をするメソッド
  @override
  Future<String?> jwtRegister(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/register'),
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
          logger.d('token log💡: ${responseData['token']}');
          logger.d('pref log💡: ${prefs.getString('token')}');
          return 'success';
        } else if (responseData['error'] != null) {
          logger.d('error log💡: ${responseData['error']}');
          return responseData['error'];
        } else {
          logger.d('error log💡: Unexpected response');
          return 'Registration Error: Unexpected response';
        }
      } else {
        return 'HTTP Error with code: ${response.statusCode}';
      }
    } catch (e) {
      logger.d('An error occurred🔥: $e');
      return 'An error occurred: $e';
    }
  }

  // JWT TOKENを削除して、ログアウトするメソッド
  @override
  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
