import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/login_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'utils/constants.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Widget chính của ứng dụng GVmarket
/// ══════════════════════════════════════════════════════════════════════════════
///
/// 5 tabs:
/// ┌──────────┬──────────┬──────────┬──────────┬──────────┐
/// │ Trang    │ Sản      │ Tài      │ Hỗ trợ   │ Giới     │
/// │ chủ      │ phẩm     │ khoản    │          │ thiệu    │
/// ├──────────┼──────────┼──────────┼──────────┼──────────┤
/// │ 🏠       │ 🛍️       │ 👤       │ 🎧       │ ℹ️       │
/// │ WebView  │ WebView  │ WebView  │ NATIVE   │ NATIVE   │
/// └──────────┴──────────┴──────────┴──────────┴──────────┘
///
/// ══════════════════════════════════════════════════════════════════════════════
class GVMarketApp extends StatelessWidget {
  const GVMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tên app
      title: AppConstants.appName,

      // Tắt banner debug
      debugShowCheckedModeBanner: false,

      // Theme
      theme: ThemeData(
        // Màu chính
        primarySwatch: Colors.blue,
        primaryColor: const Color(AppColors.primaryColorValue),

        // Màu nền
        scaffoldBackgroundColor: Colors.white,

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),

        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppColors.primaryColorValue),
            foregroundColor: Colors.white,
          ),
        ),

        // Sử dụng Material 3
        useMaterial3: true,

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppColors.primaryColorValue),
        ),
      ),

      // Màn hình chính
      home: const MainScreen(),
    );
  }
}

/// ══════════════════════════════════════════════════════════════════════════════
/// Màn hình chính với Bottom Navigation (5 tabs)
/// ══════════════════════════════════════════════════════════════════════════════
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ─────────────────────────────────────────────────────────────────────────────
  // State variables
  // ─────────────────────────────────────────────────────────────────────────────

  /// Tab hiện tại
  int _currentIndex = 0;

  /// Trạng thái đăng nhập (dùng để đổi title tab Tài khoản)
  bool _isLoggedIn = false;

  // ─────────────────────────────────────────────────────────────────────────────
  // GlobalKeys để truy cập state của các WebView screens
  // ─────────────────────────────────────────────────────────────────────────────

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey();
  final GlobalKey<CategoryScreenState> _categoryKey = GlobalKey();
  final GlobalKey<LoginScreenState> _loginKey = GlobalKey();

  // ─────────────────────────────────────────────────────────────────────────────
  // Lấy title động cho AppBar
  // ─────────────────────────────────────────────────────────────────────────────

  String get _currentTitle {
    switch (_currentIndex) {
      case 0:
        return 'GV market';
      case 1:
        return 'Sản phẩm';
      case 2:
      // Đổi title dựa trên trạng thái đăng nhập
      //   return _isLoggedIn ? 'Tài khoản' : 'Đăng nhập';
        return 'Tài khoản';
      case 3:
        return 'Hỗ trợ';
      case 4:
        return 'Giới thiệu';
      default:
        return AppConstants.appName;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build UI
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ═══════════════════════════════════════════════════════════════════════
      // AppBar
      // ═══════════════════════════════════════════════════════════════════════
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // Nút refresh cho WebView screens (tab 0, 1, 2)
        actions: _buildAppBarActions(),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // Body - IndexedStack giữ state của tất cả tabs
      // ═══════════════════════════════════════════════════════════════════════
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // ─────────────────────────────────────────────────────────────────────
          // Tab 0: TRANG CHỦ (WebView - gvmarket.vn)
          // ─────────────────────────────────────────────────────────────────────
          HomeScreen(
            key: _homeKey,
            onLoginStatusChanged: _handleLoginStatusChanged,
          ),

          // ─────────────────────────────────────────────────────────────────────
          // Tab 1: SẢN PHẨM (WebView - gvmarket.vn/shop)
          // ─────────────────────────────────────────────────────────────────────
          CategoryScreen(key: _categoryKey),

          // ─────────────────────────────────────────────────────────────────────
          // Tab 2: TÀI KHOẢN (WebView - /web/login hoặc /my)
          // ─────────────────────────────────────────────────────────────────────
          LoginScreen(
            key: _loginKey,
            isLoggedIn: _isLoggedIn,
            onLoginStatusChanged: _handleLoginStatusChanged,
          ),

          // ─────────────────────────────────────────────────────────────────────
          // Tab 3: HỖ TRỢ ⭐ NATIVE (ContactScreen)
          // - FAQ, Liên hệ, Social media
          // ─────────────────────────────────────────────────────────────────────
          const ContactScreen(),

          // ─────────────────────────────────────────────────────────────────────
          // Tab 4: GIỚI THIỆU ⭐ NATIVE (ProfileScreen)
          // - Thông tin công ty, Chính sách pháp lý
          // ─────────────────────────────────────────────────────────────────────
          const ProfileScreen(),
        ],
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // Bottom Navigation Bar (5 tabs)
      // ═══════════════════════════════════════════════════════════════════════
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Xử lý khi trạng thái đăng nhập thay đổi
  // ─────────────────────────────────────────────────────────────────────────────

  void _handleLoginStatusChanged(bool isLoggedIn) {
    // Chỉ xử lý nếu trạng thái thực sự thay đổi
    if (_isLoggedIn == isLoggedIn) return;

    setState(() {
      _isLoggedIn = isLoggedIn;
    });

    if (isLoggedIn) {
      // ✅ ĐĂNG NHẬP THÀNH CÔNG
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // ✅ ĐĂNG XUẤT
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đăng xuất'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );

      // Nếu đang ở tab Tài khoản (index 2), load lại URL đăng nhập
      if (_currentIndex == 2) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _loginKey.currentState?.loadInitialUrl();
        });
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Xử lý khi tap vào tab
  // ─────────────────────────────────────────────────────────────────────────────

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // Click vào tab đang active → Load về URL gốc (cho WebView tabs)
      _loadInitialUrlForTab(index);
    } else {
      // Chuyển sang tab khác
      _loadInitialUrlForTab(index);
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Load về URL gốc cho tab tương ứng (chỉ áp dụng cho WebView tabs)
  // ─────────────────────────────────────────────────────────────────────────────

  void _loadInitialUrlForTab(int index) {
    switch (index) {
      case 0:
      // Tab Trang chủ (WebView)
        _homeKey.currentState?.loadInitialUrl();
        break;
      case 1:
      // Tab Sản phẩm (WebView)
        _categoryKey.currentState?.loadInitialUrl();
        break;
      case 2:
      // Tab Tài khoản (WebView)
        _loginKey.currentState?.loadInitialUrl();
        break;
    // Tab 3 (Hỗ trợ) và Tab 4 (Giới thiệu) là NATIVE → không cần xử lý
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build các nút action cho AppBar
  // ─────────────────────────────────────────────────────────────────────────────

  List<Widget>? _buildAppBarActions() {
    // Chỉ hiện nút refresh cho WebView screens (tab 0, 1, 2)
    if (_currentIndex <= 2) {
      return [
        // Nút reload trang hiện tại
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Làm mới trang',
          onPressed: () {
            switch (_currentIndex) {
              case 0:
                _homeKey.currentState?.reload();
                break;
              case 1:
                _categoryKey.currentState?.reload();
                break;
              case 2:
                _loginKey.currentState?.reload();
                break;
            }
          },
        ),
        // Nút về trang chủ của tab (URL gốc)
        IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về trang gốc',
          onPressed: () {
            _loadInitialUrlForTab(_currentIndex);
          },
        ),
      ];
    }

    // Tab 3, 4 (NATIVE) → không cần nút refresh
    return null;
  }
}