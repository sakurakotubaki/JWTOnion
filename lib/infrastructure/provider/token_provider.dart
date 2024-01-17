import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// keyがtokenのSharedPreferencesを取得するProvider
final tokenProvider = FutureProvider<String?>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
});
