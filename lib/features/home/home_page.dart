import 'dart:developer';
import 'package:avenue/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  final String lang;

  const HomePage({super.key, required this.lang});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WebViewController _webViewController = WebViewController();
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initializeWebView();
    });
  }

  void _initializeWebView() async {
    _webViewController
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            log('Page finished loading: $url');
            Uri uri = Uri.parse(url);
            String? lang = uri.queryParameters['lang'];
            if (widget.lang != lang) {
              context.read<LanguageProvider>().saveLocale(Locale(lang!));
            }
          },
          onPageFinished: (String url) {},
          onUrlChange: (url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse('https://avenue.amoeba.site/?lang=${widget.lang}'),
      );
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
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) {
      _checkAndReload();
    }
  }

  Future<void> _checkAndReload() async {
    final newUrl = 'https://avenue.amoeba.site/?lang=${widget.lang}';
    final currentUrl = await _webViewController.currentUrl();

    if (currentUrl != newUrl) {
      _webViewController.loadRequest(Uri.parse(newUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: WebViewWidget(controller: _webViewController),
        ),
      ),
    );
  }
}
