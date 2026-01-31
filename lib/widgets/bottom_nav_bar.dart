import 'package:flutter/material.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Bottom Navigation Bar cho ứng dụng GVmarket
/// ══════════════════════════════════════════════════════════════════════════════
///
/// 5 tabs:
/// ┌──────────┬──────────┬──────────┬──────────┬──────────┐
/// │ Trang    │ Sản      │ Tài      │ Hỗ trợ   │ Giới     │
/// │ chủ      │ phẩm     │ khoản    │          │ thiệu    │
/// ├──────────┼──────────┼──────────┼──────────┼──────────┤
/// │ 🏠       │ 🛍️       │ 👤       │ 🎧       │ ℹ️       │
/// │ WebView  │ WebView  │ WebView  │ NATIVE   │ NATIVE   │
/// │ /        │ /shop    │ /my      │ Contact  │ Profile  │
/// └──────────┴──────────┴──────────┴──────────┴──────────┘
///
/// Tab 1: Trang chủ  → WebView gvmarket.vn
/// Tab 2: Sản phẩm   → WebView gvmarket.vn/shop
/// Tab 3: Tài khoản  → WebView đăng nhập/my account
/// Tab 4: Hỗ trợ     → NATIVE - FAQ, Liên hệ, Social media (ContactScreen)
/// Tab 5: Giới thiệu → NATIVE - Thông tin công ty, Chính sách (ProfileScreen)
///
/// ══════════════════════════════════════════════════════════════════════════════
class AppBottomNavBar extends StatelessWidget {
  /// Tab hiện tại đang được chọn (0-4)
  final int currentIndex;

  /// Callback khi người dùng chọn tab
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          // ─────────────────────────────────────────────
          // Cấu hình cơ bản
          // ─────────────────────────────────────────────
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,

          // ─────────────────────────────────────────────
          // Style
          // ─────────────────────────────────────────────
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          iconSize: 24,

          // ─────────────────────────────────────────────
          // Tab Items
          // ─────────────────────────────────────────────
          items: const [

            // ═══════════════════════════════════════════
            // TAB 1: TRANG CHỦ
            // WebView → gvmarket.vn
            // ═══════════════════════════════════════════
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Trang chủ',
            ),

            // ═══════════════════════════════════════════
            // TAB 2: SẢN PHẨM
            // WebView → gvmarket.vn/shop
            // ═══════════════════════════════════════════
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Sản phẩm',
            ),

            // ═══════════════════════════════════════════
            // TAB 3: TÀI KHOẢN
            // WebView → gvmarket.vn/web/login (chưa login)
            //         → gvmarket.vn/my (đã login)
            // ═══════════════════════════════════════════
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Tài khoản',
            ),

            // ═══════════════════════════════════════════
            // TAB 4: HỖ TRỢ ⭐ NATIVE
            // ContactScreen:
            // - FAQ (Câu hỏi thường gặp)
            // - Liên hệ (Hotline, Email, Zalo)
            // - Social media (Facebook, Instagram, YouTube)
            // ═══════════════════════════════════════════
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent_outlined),
              activeIcon: Icon(Icons.support_agent_rounded),
              label: 'Hỗ trợ',
            ),

            // ═══════════════════════════════════════════
            // TAB 5: GIỚI THIỆU ⭐ NATIVE
            // ProfileScreen:
            // - Thông tin công ty
            // - Chính sách pháp lý (6 policies)
            // ═══════════════════════════════════════════
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              activeIcon: Icon(Icons.info_rounded),
              label: 'Giới thiệu',
            ),
          ],
        ),
      ),
    );
  }
}