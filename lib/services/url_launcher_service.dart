import 'package:url_launcher/url_launcher.dart';

/// Service để xử lý việc mở các URL external (Facebook, TikTok, etc.)
///
/// Service này cung cấp:
/// - Launch URLs trong external browser/app
/// - Xử lý các loại URLs (http, https, tel, mailto, sms)
/// - Error handling
/// - Có thể tái sử dụng ở nhiều nơi trong app
///
/// Usage:
/// ```dart
/// final service = URLLauncherService();
///
/// // Launch URL
/// final success = await service.launchURL('https://www.facebook.com/GVmarket.Vietnam');
///
/// // Launch với mode cụ thể
/// await service.launchURL(
///   'https://www.tiktok.com/@gvmarket.vn',
///   mode: LaunchMode.externalApplication,
/// );
///
/// // Launch phone number
/// await service.launchPhone('0123456789');
///
/// // Launch email
/// await service.launchEmail('info@gvmarket.vn');
/// ```
class URLLauncherService {
  /// Launch một URL với mode mặc định là externalApplication
  ///
  /// Parameters:
  /// - [url]: URL cần mở (http, https, tel, mailto, sms)
  /// - [mode]: LaunchMode (default: externalApplication)
  ///   - externalApplication: Mở trong browser/app bên ngoài
  ///   - platformDefault: Để OS quyết định
  ///   - inAppWebView: Mở trong WebView (iOS Safari View Controller)
  ///   - externalNonBrowserApplication: Mở trong app native (không phải browser)
  ///
  /// Returns: true nếu launch thành công, false nếu thất bại
  Future<bool> launchURL(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final uri = Uri.parse(url);

      // Kiểm tra xem có thể launch URL không
      final canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) {
        print('Cannot launch URL: $url');
        return false;
      }

      // Launch URL
      final success = await launchUrl(
        uri,
        mode: mode,
      );

      return success;
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }

  /// Launch một URL với webViewConfiguration (cho iOS Safari View)
  ///
  /// Sử dụng cho trường hợp muốn mở trong in-app browser với tùy chỉnh
  Future<bool> launchURLInWebView(
    String url, {
    bool enableJavaScript = true,
    bool enableDomStorage = true,
  }) async {
    try {
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        print('Cannot launch URL in WebView: $url');
        return false;
      }

      final success = await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: enableJavaScript,
          enableDomStorage: enableDomStorage,
        ),
      );

      return success;
    } catch (e) {
      print('Error launching URL in WebView: $e');
      return false;
    }
  }

  /// Mở số điện thoại (tel:)
  ///
  /// Example:
  /// ```dart
  /// await service.launchPhone('0123456789');
  /// // Mở dialer với số: tel:0123456789
  /// ```
  Future<bool> launchPhone(String phoneNumber) async {
    // Remove spaces and special characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return await launchURL('tel:$cleanNumber');
  }

  /// Mở email client (mailto:)
  ///
  /// Parameters:
  /// - [email]: Địa chỉ email
  /// - [subject]: Tiêu đề email (optional)
  /// - [body]: Nội dung email (optional)
  ///
  /// Example:
  /// ```dart
  /// await service.launchEmail(
  ///   'info@gvmarket.vn',
  ///   subject: 'Hỏi về sản phẩm',
  ///   body: 'Xin chào, tôi muốn hỏi về...',
  /// );
  /// ```
  Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    return await launchURL(emailUri.toString());
  }

  /// Mở SMS app (sms:)
  ///
  /// Example:
  /// ```dart
  /// await service.launchSMS('0123456789', body: 'Hello');
  /// ```
  Future<bool> launchSMS(String phoneNumber, {String? body}) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    final smsUri = Uri(
      scheme: 'sms',
      path: cleanNumber,
      queryParameters: {
        if (body != null) 'body': body,
      },
    );

    return await launchURL(smsUri.toString());
  }

  /// Kiểm tra xem một URL có thể launch được không
  ///
  /// Useful để check trước khi launch
  Future<bool> canLaunch(String url) async {
    try {
      final uri = Uri.parse(url);
      return await canLaunchUrl(uri);
    } catch (e) {
      print('Error checking if can launch: $e');
      return false;
    }
  }

  /// Xác định loại URL (http, tel, mailto, sms, etc.)
  ///
  /// Returns: URL scheme (http, https, tel, mailto, sms, etc.)
  String? getURLScheme(String url) {
    try {
      final uri = Uri.parse(url);
      // Return null nếu scheme là empty
      return uri.scheme.isEmpty ? null : uri.scheme;
    } catch (e) {
      return null;
    }
  }

  /// Kiểm tra xem URL có phải là external link không
  ///
  /// Parameters:
  /// - [url]: URL cần check
  /// - [mainDomain]: Domain chính của app (e.g., 'gvmarket.vn')
  ///
  /// Returns: true nếu là external link
  bool isExternalLink(String url, String mainDomain) {
    try {
      final uri = Uri.parse(url);

      // Nếu không có host → không phải external link
      if (uri.host.isEmpty) return false;

      // Nếu host không chứa mainDomain → là external link
      return !uri.host.contains(mainDomain);
    } catch (e) {
      return false;
    }
  }
}
