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
/// Universal App - Hỗ trợ cả iPhone và iPad
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
/// Hỗ trợ cả iPhone và iPad với responsive layout
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
  // Helper: Kiểm tra iPad
  // ─────────────────────────────────────────────────────────────────────────────

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build UI
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ═══════════════════════════════════════════════════════════════════════
      // Body - IndexedStack giữ state của tất cả tabs
      // SafeArea đảm bảo nội dung không bị che bởi:
      // - Notch (iPhone X trở lên)
      // - Dynamic Island (iPhone 14 Pro trở lên)
      // - Punch-hole camera (Samsung, Xiaomi, etc.)
      // - Status bar (tất cả thiết bị)
      // - Home indicator trên iPad
      // ═══════════════════════════════════════════════════════════════════════
      body: SafeArea(
        // Giữ padding cho status bar phía trên
        top: true,
        // Không cần padding dưới vì đã có BottomNavigationBar
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // ─────────────────────────────────────────────────────────────────────
            // Tab 0: TRANG CHỦ (WebView - gvmarket.vn)
            // ─────────────────────────────────────────────────────────────────────
            HomeScreen(
              key: _homeKey,
              currentTabIndex: 0,
              onLoginStatusChanged: _handleLoginStatusChanged,
              onTabChangeRequested: _handleTabChangeRequest,
            ),

            // ─────────────────────────────────────────────────────────────────────
            // Tab 1: SẢN PHẨM (WebView - gvmarket.vn/shop)
            // ─────────────────────────────────────────────────────────────────────
            CategoryScreen(
              key: _categoryKey,
              currentTabIndex: 1,
              onTabChangeRequested: _handleTabChangeRequest,
            ),

            // ─────────────────────────────────────────────────────────────────────
            // Tab 2: TÀI KHOẢN (WebView - /web/login hoặc /my)
            // ─────────────────────────────────────────────────────────────────────
            LoginScreen(
              key: _loginKey,
              isLoggedIn: _isLoggedIn,
              currentTabIndex: 2,
              onLoginStatusChanged: _handleLoginStatusChanged,
              onTabChangeRequested: _handleTabChangeRequest,
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
  // Xử lý khi WebView yêu cầu chuyển tab
  // Ví dụ: User đang ở tab Trang chủ, click link /my → chuyển sang tab Tài khoản
  // ─────────────────────────────────────────────────────────────────────────────

  void _handleTabChangeRequest(int targetTabIndex) {
    // Chỉ xử lý nếu tab đích hợp lệ và khác tab hiện tại
    if (targetTabIndex == _currentIndex) return;
    if (targetTabIndex < 0 || targetTabIndex > 4) return;

    print('🔄 Tab change requested: $_currentIndex → $targetTabIndex');

    setState(() {
      _currentIndex = targetTabIndex;
    });

    // Load URL gốc cho tab đích
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadInitialUrlForTab(targetTabIndex);
    });
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
}