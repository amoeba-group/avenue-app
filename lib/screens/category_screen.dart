import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/loading_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // ✅ Định nghĩa URL gốc để dễ quản lý
  static const String _initialUrl = 'https://gvmarket.vn/shop';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(_initialUrl));
  }

  /// Reload trang hiện tại
  void reload() {
    _controller.reload();
  }

  /// ✅ MỚI: Load về URL gốc (giống click vào <a href=""> trên website)
  void loadInitialUrl() {
    setState(() {
      _isLoading = true;
    });
    _controller.loadRequest(Uri.parse(_initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const LoadingWidget(message: 'Đang tải danh mục...'),
      ],
    );
  }
}