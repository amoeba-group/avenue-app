import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/connectivity_service.dart';
import '../widgets/offline_widget.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';

/// Màn hình Trang chủ - Hiển thị WebView của website
class HomeScreen extends StatefulWidget {
  /// Callback để thông báo đã đăng nhập (từ URL)
  final Function(bool)? onLoginStatusChanged;

  const HomeScreen({
    super.key,
    this.onLoginStatusChanged,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isLoading = true;
  bool _hasError = false;
  bool _isConnected = true;
  String _currentUrl = AppConstants.homeUrl;

  /// Reload trang hiện tại
  void reload() {
    _controller.reload();
  }

  /// ✅ MỚI: Load về URL gốc (giống click vào <a href=""> trên website)
  void loadInitialUrl() {
    setState(() {
      _isLoading = true;
      _hasError = false;
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
            final url = request.url;

            if (_isExternalLink(url)) {
              _launchExternalUrl(url);
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

  bool _isExternalLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return false;
    return !uri.host.contains(AppConstants.mainDomain);
  }

  Future<void> _launchExternalUrl(String url) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mở liên kết ngoài'),
        content: const Text('Bạn có muốn mở liên kết này trong trình duyệt?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mở'),
          ),
        ],
      ),
    );

    if (shouldOpen == true) {
      // launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  /// ✅ SỬA: Chỉ thay đổi trạng thái khi URL rõ ràng cho biết login/logout
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