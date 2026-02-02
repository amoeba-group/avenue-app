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
void main() async {
  // Đảm bảo Flutter đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cấu hình orientation (chỉ cho phép portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
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
