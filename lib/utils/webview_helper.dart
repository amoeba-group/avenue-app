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
}