import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/connectivity_service.dart';
import 'services/notification_service.dart';
import 'services/local_storage_service.dart';
import 'config/env_config.dart';

/// Entry point của ứng dụng
/// 
/// Đây là nơi ứng dụng Flutter bắt đầu chạy
/// Hỗ trợ cả iPhone và iPad (Universal App)
void main() async {
  // Đảm bảo Flutter đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cấu hình orientation theo thiết bị:
  // - iPhone: chỉ portrait
  // - iPad: hỗ trợ tất cả orientations (portrait + landscape)
  if (_isTablet()) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  // Cấu hình style cho status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // Khởi tạo các services
  await _initializeServices();
  
  // Chạy ứng dụng
  runApp(const GVMarketApp());
}

/// Kiểm tra thiết bị có phải tablet (iPad) không
/// Dựa trên shortestSide của màn hình
bool _isTablet() {
  // Trên web hoặc platform không hỗ trợ → coi như phone
  if (kIsWeb) return false;
  
  // Dùng MediaQueryData từ PlatformDispatcher để check trước khi có context
  final data = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  );
  return data.size.shortestSide >= 600;
}

/// Khởi tạo các services cần thiết
Future<void> _initializeServices() async {
  // 1. Khởi tạo Environment Config
  await EnvConfig().init();

  // 2. Khởi tạo Local Storage Service (SharedPreferences)
  await LocalStorageService.init();

  // 3. Khởi tạo Connectivity Service
  ConnectivityService().initialize();

  // 4. Khởi tạo Notification Service
  await NotificationService().initialize();
}
