import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class LocalStorageService {

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  static Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static FutureOr clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
