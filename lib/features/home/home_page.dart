import 'package:avenue/managers/firebase_messaging_manager.dart';
import 'package:avenue/providers/language_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../config/env_config.dart';
import '../../generated/l10n.dart';

class HomePage extends StatefulWidget {
  final String lang;
  const HomePage({super.key, required this.lang});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController _webViewController;
  DateTime? _lastPressedAt;
  String newUrl = '';
  bool isError = false;
  String url = EnvConfig.current['urlGvMarket'];
  final ValueNotifier<bool> isDetailOrder = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _createWebView();
  }

  void _createWebView() {
    final controller = WebKitWebViewController(
      WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true),
    );
    controller.setAllowsBackForwardNavigationGestures(true);
    _webViewController = WebViewController.fromPlatform(controller)
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) async {
            Uri uri = Uri.parse(url);
            String? lang = uri.queryParameters['lang'];
            if (widget.lang != lang && lang != null) {
              context.read<LanguageProvider>().saveLocale(Locale(lang));
            }
          },
          onPageFinished: (String url) async {
            String? title = await _webViewController.getTitle();
            if (title != null && title.contains("Order Buy")) {
              isDetailOrder.value = true;
            }
            if (isError) {
              final connectivityResult = await Connectivity()
                  .checkConnectivity();
              if (connectivityResult.single != ConnectivityResult.none) {
                setState(() => isError = false);
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("$url${widget.lang}"));

    context.read<FirebaseMessagingManager>().registerTokenFCM();
  }

  Future<bool> _handleBackPress() async {
    if (isDetailOrder.value) {
      clearWebViewHistory();
      return true;
    }

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
              : Stack(
                  children: [
                    WebViewWidget(controller: _webViewController),
                    ValueListenableBuilder(
                      valueListenable: isDetailOrder,
                      builder: (context, isEnable, _) {
                        if (isEnable) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, top: 20),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  clearWebViewHistory();
                                },
                                child: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> clearWebViewHistory() async {
    setState(() {
      _createWebView();
      isDetailOrder.value = false;
    });
  }
}
