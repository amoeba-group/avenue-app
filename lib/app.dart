import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'utils/constants.dart';

/// Widget chính của ứng dụng
/// Quản lý navigation và các tab
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

/// Màn hình chính với Bottom Navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Tab hiện tại
  int _currentIndex = 0;

  // Trạng thái đăng nhập
  bool _isLoggedIn = false;

  // Keys để truy cập state của các screen
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey();
  final GlobalKey<LoginScreenState> _loginKey = GlobalKey();
  final GlobalKey<CategoryScreenState> _categoryKey = GlobalKey();

  // Lấy title động cho AppBar
  String get _currentTitle {
    switch (_currentIndex) {
      case 0:
        return 'GV market';
      case 1:
        return 'Danh mục';
      case 2:
      // Đổi title dựa trên trạng thái đăng nhập
        return _isLoggedIn ? 'Cá nhân' : 'Đăng nhập';
      case 3:
        return 'Liên hệ';
      default:
        return 'GV market';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // Nút refresh cho WebView screens
        actions: _buildAppBarActions(),
      ),

      // Body - Hiển thị screen tương ứng
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Trang chủ
          HomeScreen(
            key: _homeKey,
            onLoginStatusChanged: _handleLoginStatusChanged,
          ),

          // Tab 1: Danh mục (WebView shop)
          CategoryScreen(key: _categoryKey),

          // Tab 2: Đăng nhập / Cá nhân
          LoginScreen(
            key: _loginKey,
            isLoggedIn: _isLoggedIn,
            // ✅ SỬA: Dùng callback chung cho cả login và logout
            onLoginStatusChanged: _handleLoginStatusChanged,
          ),

          // Tab 3: Liên hệ
          const ProfileScreen(),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isLoggedIn: _isLoggedIn,
      ),
    );
  }

  /// ✅ MỚI: Xử lý khi trạng thái đăng nhập thay đổi (login hoặc logout)
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

      // Nếu đang ở tab Cá nhân (index 2), load lại URL đăng nhập
      if (_currentIndex == 2) {
        // Delay một chút để setState hoàn thành trước
        Future.delayed(const Duration(milliseconds: 100), () {
          _loginKey.currentState?.loadInitialUrl();
        });
      }
    }
  }

  /// Xử lý khi tap vào tab
  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // Click vào tab đang active → Load về URL gốc
      _loadInitialUrlForTab(index);
    } else {
      // Chuyển sang tab khác
      _loadInitialUrlForTab(index);

      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Load về URL gốc cho tab tương ứng
  void _loadInitialUrlForTab(int index) {
    switch (index) {
      case 0:
        _homeKey.currentState?.loadInitialUrl();
        break;
      case 1:
        _categoryKey.currentState?.loadInitialUrl();
        break;
      case 2:
        _loginKey.currentState?.loadInitialUrl();
        break;
    // Tab 3 (Profile) không phải WebView nên không cần xử lý
    }
  }

  /// Build các nút action cho AppBar
  List<Widget>? _buildAppBarActions() {
    // Chỉ hiện nút refresh cho WebView screens (tab 0, 1, 2)
    if (_currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2) {
      return [
        // Nút reload trang hiện tại
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Làm mới trang hiện tại',
          onPressed: () {
            if (_currentIndex == 0) {
              _homeKey.currentState?.reload();
            } else if (_currentIndex == 1) {
              _categoryKey.currentState?.reload();
            } else if (_currentIndex == 2) {
              _loginKey.currentState?.reload();
            }
          },
        ),
        // Nút về trang chủ của tab (URL gốc)
        IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Về trang chủ',
          onPressed: () {
            _loadInitialUrlForTab(_currentIndex);
          },
        ),
      ];
    }
    return null;
  }
}