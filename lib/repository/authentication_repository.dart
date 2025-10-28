import '../error/app_exception.dart';
import '../services/client_service.dart';

class AuthenticationRepository {
  final ClientService _service;

  AuthenticationRepository(this._service);

  Future<bool> login(String email, String password) async {
    try {
      final result = await _service.dio.post(
        "/login",
        data: {"email": email, "password": password},
      );
      return result.statusCode == 200;
    } on AppException catch (_) {
      rethrow;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final result = await _service.dio.post(
        "/register",
        data: {"email": email, "password": password},
      );
      return result.statusCode == 200;
    } on AppException catch (_) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      final result = await _service.dio.post("/logout");
      return result.statusCode == 200;
    } on AppException catch (_) {
      rethrow;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final result = await _service.dio.post("/forgot-password");
      return result.statusCode == 200;
    } on AppException catch (_) {
      rethrow;
    }
  }

  Future<bool> resetPassword(String password) async {
    try {
      final result = await _service.dio.post("/reset-password");
      return result.statusCode == 200;
    } on AppException catch (_) {
      rethrow;
    }
  }
}
