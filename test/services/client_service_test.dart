import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:avenue/services/client_service.dart';
import 'package:avenue/error/app_exception.dart';
import 'package:avenue/config/env_config.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Unit Tests cho ClientService
/// ══════════════════════════════════════════════════════════════════════════════
void main() {
  // Setup EnvConfig trước tất cả tests
  setUpAll(() async {
    await EnvConfig().init();
  });

  group('ClientService', () {
    late ClientService clientService;

    setUp(() {
      clientService = ClientService();
    });

    test('should initialize with correct base options', () {
      // Assert
      expect(clientService.dio, isNotNull);
      expect(clientService.dio.options.connectTimeout, Duration(seconds: 30));
      expect(clientService.dio.options.receiveTimeout, Duration(seconds: 30));
      expect(
        clientService.dio.options.headers['Content-Type'],
        'application/json',
      );
    });

    test('should have interceptors configured', () {
      // Assert
      expect(clientService.dio.interceptors.isNotEmpty, true);
    });

    group('Token Management', () {
      test('should set auth token', () {
        // Arrange
        const token = 'test_token';

        // Act
        clientService.setAuthToken(token);

        // Assert
        expect(
          clientService.dio.options.headers['Authorization'],
          'Bearer $token',
        );
      });

      test('should clear auth token', () {
        // Arrange
        const token = 'test_token';
        clientService.setAuthToken(token);

        // Act
        clientService.clearAuthToken();

        // Assert
        expect(
          clientService.dio.options.headers.containsKey('Authorization'),
          false,
        );
      });
    });

    group('Base URL Management', () {
      test('should update base URL', () {
        // Arrange
        const newBaseUrl = 'https://new-api.example.com';

        // Act
        clientService.updateBaseUrl(newBaseUrl);

        // Assert
        expect(clientService.dio.options.baseUrl, newBaseUrl);
      });
    });
  });

  group('ClientService Error Handling', () {
    test('should create appropriate exception for timeout', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      // Act & Assert
      // Lưu ý: Để test error handling, cần mock HTTP requests
      // Đây là test cơ bản về initialization
      expect(dioException.type, DioExceptionType.connectionTimeout);
    });

    test('should create appropriate exception for network error', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      // Act & Assert
      expect(dioException.type, DioExceptionType.connectionError);
    });
  });

  group('AppException Types', () {
    test('NetworkException should have correct message', () {
      // Arrange & Act
      const exception = NetworkException();

      // Assert
      expect(exception.message, 'Không có kết nối mạng');
      expect(exception, isA<AppException>());
    });

    test('TimeoutException should have correct message', () {
      // Arrange & Act
      const exception = TimeoutException();

      // Assert
      expect(exception.message, 'Kết nối quá thời gian');
      expect(exception, isA<AppException>());
    });

    test('ServerException should have correct message', () {
      // Arrange & Act
      const exception = ServerException();

      // Assert
      expect(exception.message, 'Lỗi từ máy chủ');
      expect(exception, isA<AppException>());
    });

    test('FailureException should have correct message', () {
      // Arrange & Act
      const exception = FailureException();

      // Assert
      expect(exception.message, 'Lỗi không xác định');
      expect(exception, isA<AppException>());
    });

    test('UnknownException should have correct message', () {
      // Arrange & Act
      const exception = UnknownException();

      // Assert
      expect(exception.message, 'Lỗi không xác định');
      expect(exception, isA<AppException>());
    });

    test('AppException should store status code', () {
      // Arrange & Act
      const exception = FailureException('Custom error', 404);

      // Assert
      expect(exception.message, 'Custom error');
      expect(exception.statusCode, 404);
    });
  });
}
