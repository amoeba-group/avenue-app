import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewHelper {
  /// Inject JavaScript để ẩn option "Take Photo" khi chọn file
  /// Chỉ hiển thị "Photo Library" và "Choose File"
  static void disableCameraCapture(WebViewController controller) {
    controller.runJavaScript('''
      (function() {
        function removeCaptureAttribute() {
          document.querySelectorAll('input[type="file"]').forEach(function(input) {
            input.removeAttribute('capture');
          });
        }
        
        // Chạy ngay
        removeCaptureAttribute();
        
        // Chạy lại khi DOM thay đổi
        const observer = new MutationObserver(removeCaptureAttribute);
        observer.observe(document.body, { childList: true, subtree: true });
        
        // Chạy lại sau mỗi 1 giây (backup)
        setInterval(removeCaptureAttribute, 1000);
      })();
    ''');
  }

  /// Inject viewport meta tag để đảm bảo website hiển thị đúng trên iPad
  /// Tránh trường hợp website bị zoom quá lớn hoặc quá nhỏ trên màn hình lớn
  static void injectViewportMeta(WebViewController controller) {
    controller.runJavaScript('''
      (function() {
        // Kiểm tra và cập nhật viewport meta tag
        var viewport = document.querySelector('meta[name="viewport"]');
        if (!viewport) {
          viewport = document.createElement('meta');
          viewport.name = 'viewport';
          document.head.appendChild(viewport);
        }
        viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes';
      })();
    ''');
  }

  /// Setup đầy đủ cho WebView trên cả iPhone và iPad
  /// Gọi sau khi page load xong
  static void setupForDevice(WebViewController controller, BuildContext context) {
    disableCameraCapture(controller);
    
    // Trên iPad, inject viewport meta để website hiển thị tốt hơn
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    if (isTablet) {
      injectViewportMeta(controller);
    }
  }
}