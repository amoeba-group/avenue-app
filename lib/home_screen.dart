import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _webViewController;
  bool _isShowLeading = false;
  bool _isFirstTime = true;
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              _isFirstTime = false;
            });
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            if (url != 'https://avenue.amoeba.site/') {
              if (_isShowLeading) {
                return;
              }
              setState(() {
                _isShowLeading = true;
              });
            } else {
              if (_isShowLeading) {
                setState(() {
                  _isShowLeading = false;
                });
              }
            }
          },
          onUrlChange: (url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://avenue.amoeba.site/'));
  }

  void _refreshWebView() {
    _webViewController.reload();
  }

  Future<bool> _handleBackPress() async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return false;
    }

    if (!mounted) {
      return false;
    }

    // Nếu không thể go back trong WebView, xử lý double tap to exit
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nhấn back lần nữa để thoát ứng dụng'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        appBar: AppBar(
          title: !_isShowLeading
              ? null
              : Text(
                  'Amoeba avenue',
                  style: TextStyle(
                    color: Color(0xFFFD7513),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          leading: _isShowLeading
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFFD7513),
                  ),
                  onPressed: () async {
                    if (await _webViewController.canGoBack()) {
                      _webViewController.goBack();
                    } else {
                      _handleBackPress();
                    }
                  },
                )
              : null,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFFFD7513)),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshWebView,
              tooltip: 'Làm mới',
            ),
          ],
        ),
        body: Stack(
          children: [
            !_isFirstTime
                ? WebViewWidget(controller: _webViewController)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
