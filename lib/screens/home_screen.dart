import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/connectivity_service.dart';
import '../services/url_launcher_service.dart';
import '../widgets/offline_widget.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';
import '../utils/webview_helper.dart';

/// Màn hình Trang chủ - Hiển thị WebView của website
class HomeScreen extends StatefulWidget {
  /// Callback để thông báo đã đăng nhập (từ URL)
  final Function(bool)? onLoginStatusChanged;

  /// Callback khi cần chuyển tab (URL navigate đến tab khác)
  final Function(int)? onTabChangeRequested;

  /// Tab index hiện tại của màn hình này
  final int currentTabIndex;

  const HomeScreen({
    super.key,
    this.onLoginStatusChanged,
    this.onTabChangeRequested,
    this.currentTabIndex = 0,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  final ConnectivityService _connectivityService = ConnectivityService();
  final URLLauncherService _urlLauncherService = URLLauncherService();

  bool _isLoading = true;
  bool _hasError = false;
  bool _isConnected = true;
  String _currentUrl = AppConstants.homeUrl;
  int _loadingProgress = 0;
  Timer? _loadingTimer;

  /// Reload trang hiện tại
  void reload() {
    setState(() {
      _isLoading = true;
      _loadingProgress = 0;
    });
    _controller.reload();
  }

  /// Load về URL gốc (giống click vào <a href=""> trên website)
  void loadInitialUrl() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _loadingProgress = 0;
    });
    _controller.loadRequest(Uri.parse(AppConstants.homeUrl));
  }

  void loadUrl(String url) {
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initWebView();
  }

  void _initConnectivity() {
    _connectivityService.initialize();

    _connectivityService.checkConnectivity().then((isConnected) {
      setState(() => _isConnected = isConnected);
    });

    _connectivityService.connectivityStream.listen((isConnected) {
      setState(() => _isConnected = isConnected);

      if (isConnected && _hasError) {
        _controller.reload();
      }
    });
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _currentUrl = url;
              _loadingProgress = 0;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 100;
            });
            _checkLoginStatus(url);
            _checkTabSwitch(url);  // ✅ THÊM: Kiểm tra chuyển tab
            WebViewHelper.disableCameraCapture(_controller);
          },
          onProgress: (progress) {
            setState(() {
              _loadingProgress = progress;
            });
            // Tự động ẩn loading khi đạt 90% (trang đã load đủ để tương tác)
            if (progress >= 90 && _isLoading) {
              _cancelLoadingTimer();
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            if (error.errorCode == -1 || error.errorCode == -6) return;
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (_isExternalLink(url)) {
              // Launch URL trong external browser/app (Facebook, TikTok, etc.)
              _urlLauncherService.launchURL(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onHttpError: (error) {
            if (error.response?.statusCode == 404) {
              setState(() => _hasError = true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConstants.homeUrl));
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

  /// Chỉ thay đổi trạng thái khi URL rõ ràng cho biết login/logout
  /// - /my → đã login → callback(true)
  /// - /web/login → chưa login/đã logout → callback(false)
  /// - Các URL khác (/, /shop, /product...) → KHÔNG thay đổi trạng thái
  void _checkLoginStatus(String url) {
    if (url.contains('/my')) {
      // URL trang cá nhân → đã đăng nhập
      widget.onLoginStatusChanged?.call(true);
    } else if (url.contains('/web/login')) {
      // URL trang đăng nhập → chưa đăng nhập hoặc đã logout
      widget.onLoginStatusChanged?.call(false);
    }
    // Các URL khác (/, /shop, ...) → KHÔNG gọi callback, giữ nguyên trạng thái
  }

  /// ✅ MỚI: Kiểm tra nếu URL thuộc về tab khác → yêu cầu chuyển tab
  /// Ví dụ: User ở tab Trang chủ, click link /my → chuyển sang tab Tài khoản
  void _checkTabSwitch(String url) {
    final targetTabIndex = AppConstants.getTabIndexFromUrl(url);

    // Nếu URL thuộc tab khác và khác tab hiện tại → request chuyển tab
    if (targetTabIndex != -1 && targetTabIndex != widget.currentTabIndex) {
      print('🔄 HomeScreen: URL belongs to tab $targetTabIndex, requesting tab switch');
      widget.onTabChangeRequested?.call(targetTabIndex);
    }
  }

  Future<bool> onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: RefreshIndicator(
        onRefresh: () async => _controller.reload(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (!_isConnected) {
      return OfflineWidget(
        onRetry: () {
          _connectivityService.checkConnectivity();
        },
      );
    }

    if (_hasError) {
      return AppErrorWidget(
        message: 'Không thể tải trang. Vui lòng kiểm tra kết nối và thử lại.',
        onRetry: () {
          setState(() => _hasError = false);
          _controller.reload();
        },
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const LoadingWidget(message: 'Đang tải...'),
      ],
    );
  }
}