import 'dart:async';
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
  int _loadingProgress = 0;
  Timer? _loadingTimer;

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
            setState(() {
              _isLoading = true;
              _loadingProgress = 0;
            });
            _startLoadingTimer();
          },
          onPageFinished: (_) {
            _cancelLoadingTimer();
            setState(() {
              _isLoading = false;
              _loadingProgress = 100;
            });
          },
          onProgress: (progress) {
            setState(() {
              _loadingProgress = progress;
            });
            // Tự động ẩn loading khi đạt 90%
            if (progress >= 90 && _isLoading) {
              _cancelLoadingTimer();
              setState(() => _isLoading = false);
            }
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
    setState(() {
      _isLoading = true;
      _loadingProgress = 0;
    });
    _startLoadingTimer();
    _controller.reload();
  }

  /// ✅ MỚI: Load về URL gốc (giống click vào <a href=""> trên website)
  void loadInitialUrl() {
    setState(() {
      _isLoading = true;
      _loadingProgress = 0;
    });
    _startLoadingTimer();
    _controller.loadRequest(Uri.parse(_initialUrl));
  }

  /// Bắt đầu timer để tự động ẩn loading sau 15 giây
  void _startLoadingTimer() {
    _cancelLoadingTimer();
    _loadingTimer = Timer(const Duration(seconds: 15), () {
      if (_isLoading) {
        setState(() => _isLoading = false);
        print('⏱️ Loading timeout - force hiding loading screen');
      }
    });
  }

  /// Hủy loading timer
  void _cancelLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingTimer = null;
  }

  bool _isExternalLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return false;
    return !uri.host.contains(AppConstants.mainDomain);
  }

  @override
  void dispose() {
    _cancelLoadingTimer();
    super.dispose();
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