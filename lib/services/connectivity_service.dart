import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service quản lý trạng thái kết nối mạng
/// 
/// Cách sử dụng:
/// ```dart
/// final service = ConnectivityService();
/// 
/// // Kiểm tra ngay lập tức
/// bool isConnected = await service.checkConnectivity();
/// 
/// // Lắng nghe thay đổi
/// service.connectivityStream.listen((isConnected) {
///   print('Kết nối: $isConnected');
/// });
/// ```
class ConnectivityService {
  // Singleton pattern - chỉ tạo 1 instance duy nhất
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Instance của Connectivity plugin
  final Connectivity _connectivity = Connectivity();
  
  // Stream controller để broadcast trạng thái kết nối
  final StreamController<bool> _connectivityController = 
      StreamController<bool>.broadcast();
  
  // Getter để lấy stream
  Stream<bool> get connectivityStream => _connectivityController.stream;
  
  // Trạng thái kết nối hiện tại
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  /// Khởi tạo service và bắt đầu lắng nghe
  void initialize() {
    // Kiểm tra kết nối ban đầu
    checkConnectivity();
    
    // Lắng nghe thay đổi kết nối
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  /// Kiểm tra kết nối ngay lập tức
  Future<bool> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
      return _isConnected;
    } catch (e) {
      _isConnected = false;
      _connectivityController.add(false);
      return false;
    }
  }

  /// Cập nhật trạng thái kết nối
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Kiểm tra có kết nối không (không phải none)
    final hasConnection = results.isNotEmpty && 
        !results.contains(ConnectivityResult.none);
    
    // Chỉ broadcast nếu trạng thái thay đổi
    if (_isConnected != hasConnection) {
      _isConnected = hasConnection;
      _connectivityController.add(hasConnection);
    }
  }

  /// Hủy service khi không cần nữa
  void dispose() {
    _connectivityController.close();
  }
}
