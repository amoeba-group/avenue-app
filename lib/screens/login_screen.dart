import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/connectivity_service.dart';
import '../services/local_storage_service.dart';
import '../services/url_launcher_service.dart';
import '../widgets/offline_widget.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';

/// Màn hình Đăng nhập / Cá nhân - Hiển thị WebView
/// - Chưa login: hiển thị trang đăng nhập
/// - Đã login: hiển thị trang tài khoản cá nhân
class LoginScreen extends StatefulWidget {
  /// ✅ SỬA: Callback khi trạng thái đăng nhập thay đổi (login hoặc logout)
  final Function(bool)? onLoginStatusChanged;

  /// Trạng thái đăng nhập (để biết load URL nào)
  final bool isLoggedIn;

  const LoginScreen({
    super.key,
    this.onLoginStatusChanged,
    this.isLoggedIn = false,
  });

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  final ConnectivityService _connectivityService = ConnectivityService();
  final URLLauncherService _urlLauncherService = URLLauncherService();

  bool _isLoading = true;
  bool _hasError = false;
  bool _isConnected = true;

  /// Reload trang hiện tại
  void reload() {
    _controller.reload();
  }

  /// Load về URL gốc dựa trên trạng thái đăng nhập
  /// - Đã login → load /my (trang cá nhân)
  /// - Chưa login → load /web/login (trang đăng nhập)
  void loadInitialUrl() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final url = widget.isLoggedIn
        ? AppConstants.accountUrl  // https://gvmarket.vn/my/
        : AppConstants.loginUrl;   // https://gvmarket.vn/web/login/

    _controller.loadRequest(Uri.parse(url));
  }

  /// Load trang tài khoản cá nhân
  void loadAccountUrl() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse(AppConstants.accountUrl));
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    // _initWebView() bây giờ là async, cần gọi mà không đợi
    _initWebView();
  }

  void _initConnectivity() {
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

  Future<void> _initWebView() async {
    // Load URL phù hợp với trạng thái đăng nhập ban đầu
    // Kiểm tra trạng thái đăng nhập đã lưu trong LocalStorage
    final savedLoginState = await LocalStorageService.readBool('webview_logged_in') ?? false;
    final initialUrl = (widget.isLoggedIn || savedLoginState)
        ? AppConstants.accountUrl
        : AppConstants.loginUrl;

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
            });
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _checkLoginStatus(url);
          },
          onWebResourceError: (error) {
            if (error.errorCode == -1 || error.errorCode == -6) return;
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            if (_isExternalLink(request.url)) {
              // Launch URL trong external browser/app
              _urlLauncherService.launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  bool _isExternalLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return false;
    return !uri.host.contains(AppConstants.mainDomain);
  }

  /// ✅ SỬA: Kiểm tra trạng thái đăng nhập từ URL
  /// - /my → đã đăng nhập → callback(true) và lưu state
  /// - /web/login → đã đăng xuất → callback(false) và xóa state
  void _checkLoginStatus(String url) async {
    if (url.contains('/my')) {
      // Đã đăng nhập - lưu trạng thái vào LocalStorage
      await LocalStorageService.saveBool('webview_logged_in', true);
      widget.onLoginStatusChanged?.call(true);
    } else if (url.contains('/web/login')) {
      // Đã đăng xuất hoặc chưa đăng nhập - xóa trạng thái
      await LocalStorageService.saveBool('webview_logged_in', false);
      widget.onLoginStatusChanged?.call(false);
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
        onRetry: () => _connectivityService.checkConnectivity(),
      );
    }

    if (_hasError) {
      return AppErrorWidget(
        message: widget.isLoggedIn
            ? 'Không thể tải trang cá nhân.'
            : 'Không thể tải trang đăng nhập.',
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
          LoadingWidget(
            message: widget.isLoggedIn
                ? 'Đang tải trang cá nhân...'
                : 'Đang tải...',
          ),
      ],
    );
  }
}