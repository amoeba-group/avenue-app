import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/connectivity_service.dart';
import 'services/notification_service.dart';

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
  // 1. Khởi tạo Connectivity Service
  ConnectivityService().initialize();
  
  // 2. Khởi tạo Notification Service
  // (Uncomment khi đã cấu hình Firebase)
  await NotificationService().initialize();
  
  // 3. Các service khác...
}
