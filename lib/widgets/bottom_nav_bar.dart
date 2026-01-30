import 'package:flutter/material.dart';
import 'package:avenue/widgets/bottom_nv_item.dart';

/// Bottom Navigation Bar cho ứng dụng
///
/// Bao gồm 4 tab:
/// - Trang chủ
/// - Danh mục
/// - Đăng nhập / Cá nhân (động theo trạng thái login)
/// - Liên hệ
class AppBottomNavBar extends StatelessWidget {
  /// Tab hiện tại đang được chọn
  final int currentIndex;

  /// Callback khi người dùng chọn tab
  final Function(int) onTap;

  /// ✅ MỚI: Trạng thái đăng nhập để đổi label/icon
  final bool isLoggedIn;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Đổ bóng cho navigation bar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        // Tab hiện tại
        currentIndex: currentIndex,

        // Callback khi tap
        onTap: onTap,

        // Kiểu hiển thị - fixed để luôn hiện label
        type: BottomNavigationBarType.fixed,

        // Màu sắc
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,

        // Font size
        selectedFontSize: 12,
        unselectedFontSize: 12,

        // Icon size
        iconSize: 26,

        // Các tab items
        items: [
          // Tab 1: Trang chủ
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            // icon: BottomNvItem(ic: "assets/ic_home.svg"),
            // activeIcon: BottomNvItem(ic: "assets/ic_selected_home.svg"),
            label: 'Trang chủ',
          ),

          // Tab 2: Danh mục
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Danh mục',
          ),

          // Tab 3: Đăng nhập / Cá nhân (✅ ĐỘNG theo trạng thái login)
          BottomNavigationBarItem(
            icon: Icon(
              // isLoggedIn ? Icons.person_outline : Icons.login_outlined,
              Icons.person_outline,
            ),
            activeIcon: Icon(
              // isLoggedIn ? Icons.person : Icons.login,
              Icons.person,
            ),
            // label: isLoggedIn ? 'Cá nhân' : 'Đăng nhập',
            label: 'Cá nhân',
          ),

          // Tab 4: Liên hệ
          const BottomNavigationBarItem(
            icon: Icon(Icons.contact_support_outlined),
            activeIcon: Icon(Icons.contact_support),
            label: 'Liên hệ',
          ),
        ],
      ),
    );
  }
}