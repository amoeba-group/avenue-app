import 'dart:developer';
import 'package:avenue/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: !_isShowLeading
              ? null
              : Text(
                  'GV Market',
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
              icon: Icon(Icons.logout),
              onPressed: showConfirmationLogout,
              tooltip: 'Làm mới',
            ),
          ],
        ),
        body: WebViewWidget(controller: _webViewController),
      ),
    );
  }

  void showConfirmationLogout() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Thông báo"),
        content: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text("Bạn có muốn đăng xuất không?"),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Huỷ", style: const TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("Đồng ý", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
