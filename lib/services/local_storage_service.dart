import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Local Storage Service - Quản lý lưu trữ dữ liệu local
/// ══════════════════════════════════════════════════════════════════════════════
///
/// Chức năng:
/// - Lưu/đọc dữ liệu với SharedPreferences (non-sensitive data)
/// - Lưu/đọc dữ liệu với FlutterSecureStorage (sensitive data: tokens, passwords)
/// - Type-safe methods cho các data types phổ biến
///
/// Usage:
/// ```dart
/// // Initialize (gọi trong main.dart)
/// await LocalStorageService.init();
///
/// // Save/Read string
/// await LocalStorageService.save('key', 'value');
/// final value = await LocalStorageService.read('key');
///
/// // Save/Read secure data (token, password)
/// await LocalStorageService.saveSecure('token', 'jwt_token_here');
/// final token = await LocalStorageService.readSecure('token');
/// ```
///
/// ══════════════════════════════════════════════════════════════════════════════
class LocalStorageService {
  static SharedPreferences? _preferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // ─────────────────────────────────────────────────────────────────────────────
  // Initialization - GỌI TRONG main.dart TRƯỚC KHI runApp()
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize SharedPreferences
  /// Gọi trong main.dart: await LocalStorageService.init();
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SharedPreferences Methods (NON-SENSITIVE DATA)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Lưu string value
  static Future<bool> save(String key, String value) async {
    _checkInitialized();
    return await _preferences!.setString(key, value);
  }

  /// Đọc string value
  static Future<String?> read(String key) async {
    _checkInitialized();
    return _preferences!.getString(key);
  }

  /// Lưu int value
  static Future<bool> saveInt(String key, int value) async {
    _checkInitialized();
    return await _preferences!.setInt(key, value);
  }

  /// Đọc int value
  static Future<int?> readInt(String key) async {
    _checkInitialized();
    return _preferences!.getInt(key);
  }

  /// Lưu bool value
  static Future<bool> saveBool(String key, bool value) async {
    _checkInitialized();
    return await _preferences!.setBool(key, value);
  }

  /// Đọc bool value
  static Future<bool?> readBool(String key) async {
    _checkInitialized();
    return _preferences!.getBool(key);
  }

  /// Lưu double value
  static Future<bool> saveDouble(String key, double value) async {
    _checkInitialized();
    return await _preferences!.setDouble(key, value);
  }

  /// Đọc double value
  static Future<double?> readDouble(String key) async {
    _checkInitialized();
    return _preferences!.getDouble(key);
  }

  /// Lưu list of strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    _checkInitialized();
    return await _preferences!.setStringList(key, value);
  }

  /// Đọc list of strings
  static Future<List<String>?> readStringList(String key) async {
    _checkInitialized();
    return _preferences!.getStringList(key);
  }

  /// Xóa một key
  static Future<bool> remove(String key) async {
    _checkInitialized();
    return await _preferences!.remove(key);
  }

  /// Xóa tất cả dữ liệu
  static Future<bool> clear() async {
    _checkInitialized();
    return await _preferences!.clear();
  }

  /// Check xem key có tồn tại không
  static Future<bool> containsKey(String key) async {
    _checkInitialized();
    return _preferences!.containsKey(key);
  }

  /// Lấy tất cả keys
  static Future<Set<String>> getAllKeys() async {
    _checkInitialized();
    return _preferences!.getKeys();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Secure Storage Methods (SENSITIVE DATA: tokens, passwords)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Lưu sensitive data (token, password, etc.)
  /// Data được mã hóa và lưu trong Keychain (iOS) / KeyStore (Android)
  static Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Đọc sensitive data
  static Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Xóa một key từ secure storage
  static Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Xóa tất cả secure data
  static Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  /// Check xem key có tồn tại trong secure storage không
  static Future<bool> containsKeySecure(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null;
  }

  /// Lấy tất cả secure keys
  static Future<Map<String, String>> getAllSecureData() async {
    return await _secureStorage.readAll();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helper Methods
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check xem SharedPreferences đã được initialize chưa
  static void _checkInitialized() {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService chưa được initialize! '
        'Hãy gọi LocalStorageService.init() trong main.dart',
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Common Storage Keys - Đặt ở đây để dễ quản lý
  // ─────────────────────────────────────────────────────────────────────────────

  // Authentication
  static const String keyAccessToken = 'accessToken';
  static const String keyRefreshToken = 'refreshToken';
  static const String keyUserId = 'userId';
  static const String keyUserEmail = 'userEmail';
  static const String keyIsLoggedIn = 'isLoggedIn';

  // Language
  static const String keyLocale = 'locale';

  // App Settings
  static const String keyThemeMode = 'themeMode';
  static const String keyFirstLaunch = 'isFirstLaunch';

  // FCM
  static const String keyFcmToken = 'fcmToken';
  static const String keyNotificationEnabled = 'notificationEnabled';

  // ─────────────────────────────────────────────────────────────────────────────
  // Convenience Methods - Các phương thức tiện ích cho use cases phổ biến
  // ─────────────────────────────────────────────────────────────────────────────

  /// Lưu access token (secure)
  static Future<void> saveAccessToken(String token) async {
    await saveSecure(keyAccessToken, token);
  }

  /// Đọc access token
  static Future<String?> getAccessToken() async {
    return await readSecure(keyAccessToken);
  }

  /// Xóa access token
  static Future<void> removeAccessToken() async {
    await removeSecure(keyAccessToken);
  }

  /// Lưu thông tin user sau khi login
  static Future<void> saveUserSession({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? email,
  }) async {
    await saveSecure(keyAccessToken, accessToken);
    if (refreshToken != null) {
      await saveSecure(keyRefreshToken, refreshToken);
    }
    if (userId != null) {
      await save(keyUserId, userId);
    }
    if (email != null) {
      await save(keyUserEmail, email);
    }
    await saveBool(keyIsLoggedIn, true);
  }

  /// Xóa session (logout)
  static Future<void> clearUserSession() async {
    await removeSecure(keyAccessToken);
    await removeSecure(keyRefreshToken);
    await remove(keyUserId);
    await remove(keyUserEmail);
    await saveBool(keyIsLoggedIn, false);
  }

  /// Check xem user đã login chưa
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
