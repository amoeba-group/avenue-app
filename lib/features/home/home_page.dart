import 'dart:developer';
import 'package:avenue/features/home/order_success_page.dart';
import 'package:avenue/managers/firebase_messaging_manager.dart';
import 'package:avenue/providers/language_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/env_config.dart';
import '../../generated/l10n.dart';

class HomePage extends StatefulWidget {
  final String lang;

  const HomePage({super.key, required this.lang});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WebViewController _webViewController = WebViewController();
  DateTime? _lastPressedAt;
  String newUrl = '';
  bool isError = false;
  String url = EnvConfig.current['urlGvMarket'];

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
          onPageStarted: (String url) async {
            log('Page finished loading: $url');
            Uri uri = Uri.parse(url);
            String? lang = uri.queryParameters['lang'];
            if (widget.lang != lang) {
              context.read<LanguageProvider>().saveLocale(Locale(lang!));
            }
          },
          onPageFinished: (String url) async {
            String? title = await _webViewController.getTitle();
            if (title != null && title.contains("Order Buy")) {
              _orderSuccess();
            }
            if (isError) {
              isError = false;
              setState(() {});
            }
          },
          onUrlChange: (url) {},
          onWebResourceError: (WebResourceError error) async {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult.single == ConnectivityResult.none) {
              isError = true;
              setState(() {});
            } else {
              debugPrint(
                "⚠️ Lỗi khác trong WebView: ${error.errorCode}, ${error.description}",
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("$url${widget.lang}"));
    context.read<FirebaseMessagingManager>().registerTokenFCM();
  }

  void _orderSuccess() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessPage()),
    );
    await _webViewController.loadRequest(Uri.parse("$url${widget.lang}"));
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
          content: Text(S.current.press_back_again_to_exit),
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
    final newUrl = "$url${widget.lang}";
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
          body: isError
              ? Center(
                  child: Column(
                    spacing: 20,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/error.svg",
                        height: 120,
                        width: 120,
                        theme: SvgTheme(currentColor: Color(0xFFFC9501)),
                      ),
                      InkWell(
                        onTap: () {
                          _webViewController.reload();
                        },
                        child: Text(
                          S.of(context).btn_retry,
                          style: GoogleFonts.bricolageGrotesque(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : WebViewWidget(controller: _webViewController),
        ),
      ),
    );
  }
}
