import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const keyIsLoggedIn = "is_logged_in";
  static const keyDeviceToken = "device_token";

  static Future<void> saveLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", lang);
  }

  static Future<String?> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("locale");
  }

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  static Future<void> saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyDeviceToken, token);
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyDeviceToken);
  }

  static FutureOr clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
