import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

/// Màn hình Liên hệ - Trang NATIVE (không phải WebView)
///
/// Tab "Liên hệ" - Chứa:
/// - Header với logo
/// - Các phương thức liên hệ (Hotline, Email, Website)
/// - Địa chỉ văn phòng với Google Maps
/// - Trung tâm trợ giúp (FAQ - 24 câu hỏi)
/// - Mạng xã hội
///
/// Trang này rất quan trọng để Apple approve!
/// Apple yêu cầu app phải có tính năng native, không chỉ là wrapper website
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactHeader(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Liên hệ với chúng tôi'),
              _buildContactMethodsCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Địa chỉ văn phòng'),
              _buildAddressCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Hỗ trợ'),
              _buildSupportCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Kết nối mạng xã hội'),
              _buildSocialMediaCard(context),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // HEADER
  // ============================================

  Widget _buildContactHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.support_agent, size: 32, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trung tâm hỗ trợ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chúng tôi luôn sẵn sàng hỗ trợ bạn!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ============================================
  // CONTACT METHODS CARD
  // ============================================

  Widget _buildContactMethodsCard(BuildContext context) {
    return _buildCard(
      children: [
        _buildContactItem(
          context,
          icon: Icons.phone,
          iconColor: Colors.green,
          title: 'Hotline',
          subtitle: AppConstants.companyPhone,
          description: 'Thứ 2 - Thứ 7: 8:00 - 17:30',
          onTap: () => _launchPhone(AppConstants.companyPhone),
        ),
        _buildContactItem(
          context,
          icon: Icons.email,
          iconColor: Colors.blue,
          title: 'Email',
          subtitle: AppConstants.companyEmail,
          description: 'Phản hồi trong vòng 24 giờ',
          onTap: () => _launchEmail(AppConstants.companyEmail),
        ),
        _buildContactItem(
          context,
          icon: Icons.language,
          iconColor: Colors.purple,
          title: 'Website',
          subtitle: AppConstants.companyWebsite,
          description: 'Truy cập website chính thức',
          onTap: () => _launchUrl('https://${AppConstants.companyWebsite}'),
        ),
      ],
    );
  }

  Widget _buildContactItem(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String subtitle,
        required String description,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // ============================================
  // ADDRESS CARD
  // ============================================

  Widget _buildAddressCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on, color: Colors.red, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Văn phòng chính', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(height: 2),
                      Text(
                        AppConstants.companyAddress,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _launchMaps(AppConstants.companyAddress),
                icon: const Icon(Icons.map),
                label: const Text('Xem trên Google Maps'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // SUPPORT CARD
  // ============================================

  Widget _buildSupportCard(BuildContext context) {
    return _buildCard(
      children: [
        _buildMenuItem(context, Icons.help_outline, 'Trung tâm trợ giúp', 'Câu hỏi thường gặp (FAQ)', () => _showHelpCenter(context)),
        _buildMenuItem(context, Icons.chat_bubble_outline, 'Chat hỗ trợ', 'Liên hệ CSKH trực tuyến', () => _showContactSupport(context)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // ============================================
  // SOCIAL MEDIA CARD
  // ============================================

  Widget _buildSocialMediaCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ─────────────────────────────────────────────
            // Facebook
            // ─────────────────────────────────────────────
            _buildSocialButton(
              icon: Icons.facebook,
              color: const Color(0xFF1877F2),
              label: 'Facebook',
              onTap: () => _launchUrl('https://www.facebook.com/GVmarket.Vietnam'),
            ),

            // ─────────────────────────────────────────────
            // TikTok - Background đen, icon trắng
            // ─────────────────────────────────────────────
            _buildSocialButton(
              icon: Icons.music_note_rounded,
              color: const Color(0xFF000000),
              backgroundColor: const Color(0xFF000000), // Background đen
              iconColor: Colors.white,                   // Icon trắng
              label: 'TikTok',
              onTap: () => _launchUrl('https://www.tiktok.com/@gvmarket.vn'),
            ),

            // ─────────────────────────────────────────────
            // Shopee
            // ─────────────────────────────────────────────
            _buildSocialButton(
              icon: Icons.shopping_bag_rounded,
              color: const Color(0xFFEE4D2D), // Màu cam Shopee
              label: 'Shopee',
              onTap: () => _launchUrl('https://shopee.vn/newkbrand'),
            ),

            // ─────────────────────────────────────────────
            // Email - NATIVE deep link
            // ─────────────────────────────────────────────
            _buildSocialButton(
              icon: Icons.email_rounded,
              color: const Color(0xFFEA4335), // Màu đỏ Gmail
              label: 'Email',
              onTap: () => _launchEmail(AppConstants.companyEmail),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // ✅ ĐÃ SỬA: Thêm backgroundColor và iconColor
  // ============================================
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    Color? backgroundColor,  // ✅ MỚI: Màu nền tùy chỉnh
    Color? iconColor,        // ✅ MỚI: Màu icon tùy chỉnh
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // ✅ Dùng backgroundColor nếu có, không thì dùng color.withOpacity(0.1)
                color: backgroundColor ?? color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                // ✅ Dùng iconColor nếu có, không thì dùng color
                color: iconColor ?? color,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ============================================
  // REUSABLE COMPONENTS
  // ============================================

  Widget _buildCard({required List<Widget> children}) {
    List<Widget> childrenWithDividers = [];
    for (int i = 0; i < children.length; i++) {
      childrenWithDividers.add(children[i]);
      if (i < children.length - 1) {
        childrenWithDividers.add(Divider(height: 1, thickness: 1, indent: 82, color: Colors.grey[200]));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: childrenWithDividers),
    );
  }

  // ============================================
  // LAUNCH FUNCTIONS
  // ============================================

  Future<void> _launchPhone(String phone) async {
    final cleanPhone = phone.replaceAll(' ', '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ============================================
  // HELP CENTER (FAQ)
  // ============================================

  void _showHelpCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(child: Text('Trung tâm trợ giúp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CÂU HỎI THƯỜNG GẶP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 16),

                    // ==========================================
                    // 1. ĐẶT HÀNG & THANH TOÁN
                    // ==========================================
                    _buildHelpSectionHeader(Icons.shopping_cart, 'Đặt hàng & Thanh toán', Colors.blue),

                    _buildQA(
                      question: 'Làm thế nào để đặt hàng?',
                      answer: 'Truy cập website/ứng dụng → Chọn sản phẩm → Thêm vào giỏ hàng → Nhập thông tin giao hàng → Chọn phương thức thanh toán → Xác nhận đơn hàng.',
                    ),
                    _buildQA(
                      question: 'GVmarket hỗ trợ phương thức thanh toán nào?',
                      answer: '• COD (thanh toán khi nhận hàng)\n• Chuyển khoản ngân hàng\n• Thẻ ATM nội địa\n• Thẻ quốc tế: Visa, MasterCard, JCB',
                    ),
                    _buildQA(
                      question: 'Khi chuyển khoản cần ghi nội dung gì?',
                      answer: 'Ghi rõ: "Tên người đặt hàng – Số điện thoại – Mã đơn hàng"',
                    ),
                    _buildQA(
                      question: 'Thanh toán có an toàn không?',
                      answer: 'Có. Hệ thống tuân thủ chuẩn bảo mật PCI DSS. Chúng tôi không lưu giữ thông tin thẻ/tài khoản.',
                    ),

                    const Divider(height: 32),

                    // ==========================================
                    // 2. VẬN CHUYỂN & GIAO NHẬN
                    // ==========================================
                    _buildHelpSectionHeader(Icons.local_shipping, 'Vận chuyển & Giao nhận', Colors.orange),

                    _buildQA(
                      question: 'GVmarket giao hàng trong bao lâu?',
                      answer: '• Nội thành HN/HCM: 1 – 2 ngày\n• Các tỉnh khác: 2 – 5 ngày\n• Khu vực xa, hải đảo: 5 – 7 ngày',
                    ),
                    _buildQA(
                      question: 'Phí vận chuyển tính như thế nào?',
                      answer: '• MIỄN PHÍ vận chuyển cho đơn từ 1.000.000 VNĐ\n• Đơn dưới mức trên: phí tính theo biểu phí của đơn vị vận chuyển',
                    ),
                    _buildQA(
                      question: 'Làm sao để theo dõi đơn hàng?',
                      answer: 'Đăng nhập tài khoản → Đơn hàng của tôi → Xem chi tiết và mã vận đơn.',
                    ),
                    _buildQA(
                      question: 'Cần làm gì khi nhận hàng?',
                      answer: '• Kiểm tra kỹ tình trạng hàng hóa\n• Nếu phát hiện lỗi → Từ chối nhận và liên hệ ngay hotline\n• Khuyến nghị: Quay video mở hộp',
                    ),

                    const Divider(height: 32),

                    // ==========================================
                    // 3. ĐỔI TRẢ & HOÀN TIỀN
                    // ==========================================
                    _buildHelpSectionHeader(Icons.autorenew, 'Đổi trả & Hoàn tiền', Colors.green),

                    _buildQA(
                      question: 'Thời hạn đổi trả là bao lâu?',
                      answer: '07 ngày kể từ ngày nhận hàng.',
                    ),
                    _buildQA(
                      question: 'Trường hợp nào được đổi trả?',
                      answer: '• Sản phẩm bị lỗi kỹ thuật từ nhà sản xuất\n• Sản phẩm bị hư hỏng do vận chuyển\n• Giao sai số lượng, mẫu mã',
                    ),
                    _buildQA(
                      question: 'Trường hợp nào KHÔNG được đổi trả?',
                      answer: '• Sản phẩm quà tặng, khuyến mãi\n• Quá thời hạn 07 ngày\n• Đã sử dụng, bóc tem/niêm phong',
                    ),
                    _buildQA(
                      question: 'Thời gian hoàn tiền là bao lâu?',
                      answer: '• Ví điện tử: 3 – 5 ngày làm việc\n• Chuyển khoản: 5 – 7 ngày làm việc',
                    ),

                    const Divider(height: 32),

                    // ==========================================
                    // 4. BẢO HÀNH
                    // ==========================================
                    _buildHelpSectionHeader(Icons.verified_user, 'Bảo hành', Colors.purple),

                    _buildQA(
                      question: 'Sản phẩm có được bảo hành không?',
                      answer: 'Có. Sản phẩm còn thời hạn sẽ được bảo hành theo tiêu chuẩn của nhà sản xuất.',
                    ),
                    _buildQA(
                      question: 'Trường hợp nào KHÔNG được bảo hành?',
                      answer: '• Hết thời hạn bảo hành\n• Hư hỏng do sử dụng sai cách\n• Không có hóa đơn mua hàng',
                    ),

                    const Divider(height: 32),

                    // ==========================================
                    // 5. TÀI KHOẢN & BẢO MẬT
                    // ==========================================
                    _buildHelpSectionHeader(Icons.security, 'Tài khoản & Bảo mật', Colors.teal),

                    _buildQA(
                      question: 'Thông tin cá nhân có được bảo mật không?',
                      answer: 'Có. GVmarket cam kết không bán, trao đổi thông tin cho bên thứ ba. Mã hóa dữ liệu SSL 256-bit.',
                    ),
                    _buildQA(
                      question: 'Tôi quên mật khẩu, phải làm sao?',
                      answer: 'Nhấn "Quên mật khẩu" tại trang đăng nhập → Nhập email/SĐT → Làm theo hướng dẫn.',
                    ),

                    const SizedBox(height: 16),

                    // Box: Liên hệ nhanh
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.headset_mic, color: Colors.blue, size: 24),
                              SizedBox(width: 8),
                              Text('Cần hỗ trợ thêm?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Text('Hotline: ${AppConstants.companyPhone}', style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text('Email: ${AppConstants.companyEmail}', style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSectionHeader(IconData icon, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildQA({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q: $question', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text('A: $answer', style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  // ============================================
  // CONTACT SUPPORT
  // ============================================

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ hỗ trợ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Gọi Hotline'),
              subtitle: Text(AppConstants.companyPhone),
              onTap: () {
                Navigator.pop(context);
                _launchPhone(AppConstants.companyPhone);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Gửi Email'),
              subtitle: Text(AppConstants.companyEmail),
              onTap: () {
                Navigator.pop(context);
                _launchEmail(AppConstants.companyEmail);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.orange),
              title: const Text('Chat Zalo'),
              subtitle: const Text('Hỗ trợ nhanh qua Zalo'),
              onTap: () {
                Navigator.pop(context);
                _launchUrl('https://zalo.me/0282112280');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}