import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../error/app_exception.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// HTTP Client Service sử dụng Dio
/// ══════════════════════════════════════════════════════════════════════════════
///
/// Chức năng:
/// - Centralized HTTP client configuration
/// - Request/Response interceptors
/// - Error handling và retry logic
/// - Authentication token management
/// - Logging (debug mode)
///
/// ══════════════════════════════════════════════════════════════════════════════
class ClientService {
  late final Dio _dio;

  Dio get dio => _dio;

  ClientService() {
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Base Configuration
  // ─────────────────────────────────────────────────────────────────────────────

  BaseOptions _createBaseOptions() {
    final baseUrl = EnvConfig.current['apiBaseUrl'] ?? 'https://gvmarket.vn/api';

    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Chấp nhận tất cả status codes để xử lý custom
        return status != null && status < 500;
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Interceptors Setup
  // ─────────────────────────────────────────────────────────────────────────────

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Logging interceptor (chỉ trong debug mode)
    // TODO: Enable logging based on environment
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Request Interceptor - Thêm token vào header
  // ─────────────────────────────────────────────────────────────────────────────

  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Lấy token từ LocalStorageService và thêm vào header
    // final token = await LocalStorageService.read('accessToken');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    handler.next(options);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Response Interceptor - Xử lý response thành công
  // ─────────────────────────────────────────────────────────────────────────────

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Response thành công (200-299)
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      handler.next(response);
      return;
    }

    // Response lỗi (400-499)
    if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
      final error = _createErrorFromResponse(response);
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: error,
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    handler.next(response);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Error Interceptor - Convert DioException thành AppException
  // ─────────────────────────────────────────────────────────────────────────────

  void _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) {
    AppException appException;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        appException = TimeoutException(
          'Kết nối quá chậm. Vui lòng thử lại.',
          error.response?.statusCode,
        );
        break;

      case DioExceptionType.badResponse:
        appException = _createErrorFromResponse(error.response);
        break;

      case DioExceptionType.cancel:
        appException = UnknownException(
          'Yêu cầu đã bị hủy',
          null,
        );
        break;

      case DioExceptionType.connectionError:
        appException = NetworkException(
          'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.',
          null,
        );
        break;

      case DioExceptionType.badCertificate:
        appException = ServerException(
          'Lỗi bảo mật kết nối',
          null,
        );
        break;

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          appException = NetworkException(
            'Không có kết nối mạng',
            null,
          );
        } else {
          appException = UnknownException(
            'Đã có lỗi xảy ra. Vui lòng thử lại.',
            null,
          );
        }
        break;
    }

    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: appException,
        type: error.type,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Tạo AppException từ Response
  // ─────────────────────────────────────────────────────────────────────────────

  AppException _createErrorFromResponse(Response? response) {
    if (response == null) {
      return UnknownException('Không có phản hồi từ server', null);
    }

    final statusCode = response.statusCode;
    final data = response.data;

    // Extract error message từ response body
    String message = 'Đã có lỗi xảy ra';
    if (data is Map) {
      message = data['message'] ?? data['error'] ?? message;
    }

    // HTTP Status Code handling
    switch (statusCode) {
      case 400:
        return FailureException(message, statusCode);
      case 401:
        return FailureException(
          'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.',
          statusCode,
        );
      case 403:
        return FailureException(
          'Bạn không có quyền thực hiện thao tác này',
          statusCode,
        );
      case 404:
        return FailureException('Không tìm thấy dữ liệu', statusCode);
      case 422:
        return FailureException(message, statusCode);
      case 500:
      case 502:
      case 503:
        return ServerException('Lỗi server. Vui lòng thử lại sau.', statusCode);
      default:
        return UnknownException(message, statusCode);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Public Methods - Thêm/Xóa token
  // ─────────────────────────────────────────────────────────────────────────────

  /// Thêm Bearer token vào header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Xóa token khỏi header (khi logout)
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Update base URL (nếu cần switch giữa environments)
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }
}
