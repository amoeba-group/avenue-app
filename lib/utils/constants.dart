/// File chứa các hằng số của ứng dụng
/// Thay đổi các giá trị này theo nhu cầu của bạn

class AppConstants {
  // ============================================
  // THÔNG TIN WEBSITE
  // ============================================
  
  /// URL trang chủ website
  static const String homeUrl = 'https://gvmarket.vn/';
  
  /// URL trang đăng nhập
  static const String loginUrl = 'https://gvmarket.vn/web/login/';
  
  /// URL trang tài khoản (sau khi đã đăng nhập)
  static const String accountUrl = 'https://gvmarket.vn/my/';
  
  /// Domain chính (để kiểm tra link internal/external)
  static const String mainDomain = 'gvmarket.vn';
  
  // ============================================
  // THÔNG TIN CÔNG TY
  // ============================================
  
  /// Tên công ty
  static const String companyName = 'CÔNG TY TNHH  Brand New K';
  
  /// Địa chỉ công ty
  static const String companyAddress = '11A đường số 52, KDC Văn Minh, phường Bình Trưng, Thành Phố Hồ Chí Minh';
  
  /// Số điện thoại
  static const String companyPhone = '028 2211 2280';
  
  /// Email hỗ trợ
  static const String companyEmail = 'brandnewk.marketing@gmail.com';
  
  /// Website
  static const String companyWebsite = 'https://gvmarket.vn';
  
  /// Mã số thuế
  static const String companyTaxCode = '0317785276';
  
  // ============================================
  // THÔNG TIN ỨNG DỤNG
  // ============================================
  
  /// Tên ứng dụng
  static const String appName = 'GV market';
  
  /// Phiên bản ứng dụng
  static const String appVersion = '1.0.0';
  
  /// Mô tả ngắn
  static const String appDescription = 'Ứng dụng mua sắm trực tuyến tiện lợi';
}

/// Các màu sắc chính của ứng dụng
class AppColors {
  // Màu chính - Thay đổi theo brand của bạn
  static const int primaryColorValue = 0xFF2196F3;  // Xanh dương
  static const int secondaryColorValue = 0xFF4CAF50; // Xanh lá
  static const int accentColorValue = 0xFFFF9800;   // Cam
  
  // Màu nền
  static const int backgroundColorValue = 0xFFF5F5F5;
  static const int cardColorValue = 0xFFFFFFFF;
  
  // Màu text
  static const int textPrimaryValue = 0xFF212121;
  static const int textSecondaryValue = 0xFF757575;
}
