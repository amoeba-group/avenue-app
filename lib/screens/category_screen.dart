import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/url_launcher_service.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  late final WebViewController _controller;
  final URLLauncherService _urlLauncherService = URLLauncherService();

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
          onNavigationRequest: (request) {
            if (_isExternalLink(request.url)) {
              // Launch URL trong external browser/app (Facebook, TikTok, etc.)
              _urlLauncherService.launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
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

  bool _isExternalLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return false;
    return !uri.host.contains(AppConstants.mainDomain);
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