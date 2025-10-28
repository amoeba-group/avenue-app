import 'dart:io';
import 'package:avenue/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../error/app_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../features/auth/login/login_page.dart';
import '../generated/l10n.dart';
import '../utils/app_utils.dart';
import 'local_storage_service.dart';

class ClientService {
  late Dio dio;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ClientService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains("login") ||
              options.path.contains("register")) {
            return handler.next(options);
          }

          final token = await _secureStorage.read(key: accessToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final RequestOptions options = error.requestOptions;
          if (options.path.contains("register") ||
              options.path.contains("login") ||
              options.path.contains("reset-password")) {
            return handler.next(error);
          }
          if (error.response?.statusCode == 401) {
            final context = navigatorKey.currentState!.context;
            AppUtils.showErrorDialog(context, message: S.current.error_session_expired,callBack: () {
              LocalStorageService.clear("is_logged_in");
              LocalStorageService.clear("device_token");
              LocalStorageService.clear(keyEmail);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            });
            return;
          }
          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnknownException('$e');
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw UnknownException('$e');
    }
  }


  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: accessToken);
    return token != null;
  }

  Future<void> clearAuthentication() async {
    await _secureStorage.delete(key: accessToken);
    await _secureStorage.delete(key: refreshToken);
  }

  AppException _handleError(DioException e) {
    late AppException exception = UnknownException(S.current.error_unknown);

    if (e.response != null) {
      if (e.response!.data is Map) {
        if (e.response!.data['message'] != null) {
          exception = FailureException(e.response!.data['message']);
        }
      } else if (e.response!.statusCode == 403) {
        exception = ServerException(S.current.error_permission_denied);
      } else if (e.response!.statusCode == 404) {
        exception = ServerException(S.current.error_not_found);
      } else if (e.response!.statusCode == 422) {
        exception = ServerException(S.current.error_invalid_data);
      } else if (e.response!.statusCode! >= 500) {
        exception = ServerException(S.current.error_server);
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      exception = TimeoutException(S.current.error_connection_timeout);
    } else if (e.type == DioExceptionType.receiveTimeout) {
      exception = TimeoutException(S.current.error_receive_timeout);
    } else if (e.type == DioExceptionType.sendTimeout) {
      exception = TimeoutException(S.current.error_send_timeout);
    } else if (e.type == DioExceptionType.cancel) {
      exception = ServerException(S.current.error_request_cancelled);
    } else if (e.error is SocketException) {
      exception = NetworkException(S.current.error_network_unreachable);
    }

    return exception;
  }
}
