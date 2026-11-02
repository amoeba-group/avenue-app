abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, this.statusCode);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Không có kết nối mạng',
    super.statusCode,
  ]);
}

class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'Kết nối quá thời gian',
    super.statusCode,
  ]);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Lỗi từ máy chủ', super.statusCode]);
}

class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Lỗi không xác định',
    super.statusCode,
  ]);
}

class FailureException extends AppException {
  const FailureException([
    super.message = 'Lỗi không xác định',
    super.statusCode,
  ]);
}
