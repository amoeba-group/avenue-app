import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Màn hình Profile - Trang NATIVE (không phải WebView)
///
/// Tab "Cá nhân" - Chứa:
/// - Header với logo và tên app
/// - Thông tin công ty
/// - Cài đặt & Pháp lý (6 chính sách)
///
/// Trang này rất quan trọng để Apple approve!
/// Apple yêu cầu app phải có tính năng native, không chỉ là wrapper website
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              _buildProfileHeader(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Thông tin công ty'),
              _buildCompanyInfoCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Cài đặt & Pháp lý'),
              _buildSettingsCard(context),
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
  // HEADER & CARDS
  // ============================================

  Widget _buildProfileHeader(BuildContext context) {
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
            width: 70,
            height: 70,
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
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo_sq_w.jpg',
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.store,
                      size: 36,
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appDescription,
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

  Widget _buildCompanyInfoCard(BuildContext context) {
    return _buildCard(
      children: [
        _buildInfoItem(Icons.business, 'Tên công ty', AppConstants.companyName),
        _buildInfoItem(Icons.location_on, 'Địa chỉ', AppConstants.companyAddress),
        _buildInfoItem(Icons.phone, 'Hotline', AppConstants.companyPhone),
        _buildInfoItem(Icons.email, 'Email', AppConstants.companyEmail),
        _buildInfoItem(Icons.language, 'Website', AppConstants.companyWebsite),
        _buildInfoItem(Icons.numbers, 'Mã số thuế', AppConstants.companyTaxCode),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return _buildCard(
      children: [
        _buildMenuItem(context, Icons.description, 'Điều khoản sử dụng', () => _showTermsAndConditions(context)),
        _buildMenuItem(context, Icons.privacy_tip, 'Chính sách bảo mật', () => _showPrivacyPolicy(context)),
        _buildMenuItem(context, Icons.autorenew, 'Chính sách đổi trả', () => _showReturnPolicy(context)),
        _buildMenuItem(context, Icons.payment, 'Chính sách thanh toán', () => _showPaymentPolicy(context)),
        _buildMenuItem(context, Icons.verified_user, 'Chính sách bảo hành', () => _showWarrantyPolicy(context)),
        _buildMenuItem(context, Icons.local_shipping, 'Chính sách vận chuyển', () => _showShippingPolicy(context)),
      ],
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
        childrenWithDividers.add(_buildDivider());
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

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, indent: 54, color: Colors.grey[200]);
  }

  // ============================================
  // CONTENT DIALOG COMPONENTS
  // ============================================

  Widget _buildContentSection({
    required String title,
    required List<String> items,
    bool isNumberedList = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          if (title.isNotEmpty) const SizedBox(height: 8),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNumberedList ? '${index + 1}. ' : '• ',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 14, height: 1.5))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContentParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6)),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Liên hệ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(AppConstants.companyEmail, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(AppConstants.companyPhone, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // DIALOG FUNCTIONS
  // ============================================

  void _showTermsAndConditions(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Điều khoản sử dụng',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ĐIỀU KIỆN GIAO DỊCH CHUNG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildContentParagraph(
              'Khi truy cập và sử dụng website https://gvmarket.vn/ (sau đây gọi là "Website"), '
                  'Quý khách đồng ý với các điều kiện giao dịch chung dưới đây. Chúng tôi có quyền '
                  'điều chỉnh, bổ sung các điều kiện này vào bất kỳ thời điểm nào và sẽ công bố công khai '
                  'trên Website. Việc tiếp tục sử dụng dịch vụ sau khi có thay đổi đồng nghĩa với việc '
                  'Quý khách chấp nhận các nội dung đã được cập nhật.',
            ),
            _buildContentSection(
              title: 'Điều 1. Nguyên tắc chung',
              items: [
                'Website được xây dựng và vận hành bởi GVmarket nhằm cung cấp thông tin, giới thiệu và bán sản phẩm/dịch vụ đến người tiêu dùng.',
                'Khách hàng khi tham gia giao dịch trên Website được hiểu là đã tìm hiểu, đồng ý và tuân thủ các điều kiện giao dịch chung cũng như các chính sách liên quan được công bố tại Website.',
              ],
            ),
            _buildContentSection(
              title: 'Điều 2. Phạm vi áp dụng',
              items: [
                'Website cung cấp sản phẩm/dịch vụ trên toàn lãnh thổ Việt Nam. Việc cung cấp sản phẩm/dịch vụ ra ngoài lãnh thổ Việt Nam (nếu có) sẽ tuân theo quy định riêng được công bố kèm theo từng sản phẩm.',
                'Website có thể tạm ngừng hoạt động để bảo trì, nâng cấp hoặc khắc phục sự cố kỹ thuật, trong trường hợp đó chúng tôi sẽ thông báo trên Website trước (nếu có thể).',
              ],
            ),
            _buildContentSection(
              title: 'Điều 3. Quy trình giao dịch',
              items: [
                'Khách hàng truy cập Website, lựa chọn sản phẩm/dịch vụ, thực hiện đặt hàng và cung cấp đầy đủ thông tin cá nhân cần thiết.',
                'Hệ thống Website ghi nhận đơn hàng.',
                'Khách hàng tiến hành thanh toán theo phương thức đã lựa chọn (nếu có).',
                'Sau khi hệ thống xác nhận thông tin đặt hàng và/hoặc thanh toán thành công, Website sẽ gửi thông tin xác nhận đơn hàng qua email/điện thoại cho Quý khách.',
                'Website tiến hành giao hàng/cung cấp dịch vụ theo thỏa thuận.',
                'Quý khách có quyền khiếu nại, yêu cầu đổi trả hoặc bảo hành theo chính sách công bố.',
                'Mọi biểu phí, thời gian xử lý, điều kiện hạn chế (nếu có) sẽ được công bố công khai trong từng chính sách liên quan (vận chuyển, thanh toán, đổi trả, hoàn tiền).',
                'Chính sách bảo hành: GVmarket áp dụng chính sách bảo hành theo quy định của nhà sản xuất đối với từng sản phẩm cụ thể. Chi tiết điều kiện, thời hạn và phạm vi bảo hành được công bố tại phần thông tin sản phẩm hoặc phiếu bảo hành đi kèm. Với sản phẩm không có chính sách bảo hành riêng, GVmarket không chịu trách nhiệm bảo hành ngoài phạm vi lỗi sản xuất/nhà cung cấp.',
              ],
              // isNumberedList: true,
            ),
            _buildContentSection(
              title: 'Điều 4. Quyền và nghĩa vụ của GVmarket',
              items: [
                'Đảm bảo chất lượng hàng hóa/dịch vụ cung cấp đúng như thông tin đã công bố trên Website.',
                'Cung cấp đầy đủ hóa đơn, chứng từ theo quy định pháp luật (nếu có).',
                'Duy trì hoạt động bình thường, an toàn và bảo mật của Website, trừ trường hợp bất khả kháng.',
                'Bảo mật thông tin khách hàng theo chính sách bảo mật được công bố.',
                'Có quyền từ chối, hủy đơn hàng trong trường hợp: (i) khách hàng cung cấp thông tin không chính xác; (ii) khách hàng vi phạm nghĩa vụ thanh toán; hoặc (iii) sản phẩm/dịch vụ không còn khả năng cung cấp.',
                'Có quyền giới hạn số lượng sản phẩm trên mỗi đơn hàng hoặc từ chối các đơn hàng bất thường (ví dụ: đặt số lượng lớn bất thường, nghi ngờ mục đích đầu cơ hoặc gian lận).',
              ],
            ),
            _buildContentSection(
              title: 'Điều 5. Quyền và nghĩa vụ của khách hàng',
              items: [
                'Cung cấp thông tin chính xác, đầy đủ khi đăng ký và đặt hàng.',
                'Thanh toán đầy đủ giá trị đơn hàng theo đúng phương thức đã lựa chọn.',
                'Không sử dụng Website để thực hiện các hành vi gian lận, vi phạm pháp luật, gây cản trở hoặc ảnh hưởng đến quyền lợi của Website và khách hàng khác.',
                'Kiểm tra tình trạng hàng hóa/dịch vụ ngay khi nhận và phản hồi kịp thời cho Website nếu phát sinh khiếu nại.',
                'Chịu trách nhiệm về tính hợp pháp của thông tin do Quý khách cung cấp.',
                'Có trách nhiệm bảo mật thông tin tài khoản (tên đăng nhập, mật khẩu) và chịu trách nhiệm đối với mọi hoạt động phát sinh từ tài khoản của mình trên Website.',
              ],
            ),
            _buildContentSection(
              title: 'Điều 6. Quyền sở hữu trí tuệ',
              items: [
                'Toàn bộ nội dung, thiết kế, hình ảnh, phần mềm, mã nguồn, cơ sở dữ liệu, nhãn hiệu, biểu trưng và các tài sản trí tuệ khác hiển thị trên Website thuộc quyền sở hữu hợp pháp của GVmarket hoặc bên thứ ba được cấp phép.',
                'Nghiêm cấm mọi hành vi sao chép, phát tán, sử dụng cho mục đích thương mại nếu không có sự đồng ý bằng văn bản từ GVmarket.',
              ],
            ),
            _buildContentSection(
              title: 'Điều 7. Giới hạn trách nhiệm và miễn trừ trách nhiệm',
              items: [
                'GVmarket không chịu trách nhiệm trong trường hợp dịch vụ bị gián đoạn do sự cố kỹ thuật, bất khả kháng hoặc nguyên nhân khách quan ngoài khả năng kiểm soát.',
                'GVmarket không chịu trách nhiệm với những thiệt hại phát sinh từ việc Quý khách sử dụng Website không đúng hướng dẫn hoặc vi phạm pháp luật.',
                'GVmarket không chịu trách nhiệm đối với những thiệt hại gián tiếp, hệ quả hoặc mất lợi nhuận phát sinh từ việc sử dụng Website hoặc sản phẩm/dịch vụ.',
                'Trong mọi trường hợp, trách nhiệm tối đa của GVmarket đối với khách hàng (nếu có) sẽ không vượt quá tổng giá trị đơn hàng gây tranh chấp.',
              ],
            ),
            _buildContentSection(
              title: 'Điều 8. Giải quyết tranh chấp',
              items: [
                'Mọi tranh chấp phát sinh từ giao dịch trên Website sẽ được ưu tiên giải quyết bằng thương lượng và hòa giải.',
                'Nếu không đạt được thỏa thuận, tranh chấp sẽ được giải quyết tại Tòa án hoặc cơ quan có thẩm quyền theo quy định của pháp luật Việt Nam.',
              ],
            ),
            _buildContentSection(
              title: 'Điều 9. Hiệu lực thi hành',
              items: [
                'Các điều kiện giao dịch chung này có hiệu lực kể từ ngày đăng tải trên Website.',
                'Chúng tôi có quyền sửa đổi, bổ sung nội dung vào bất kỳ thời điểm nào. Quý khách vui lòng thường xuyên truy cập Website và cập nhật thông tin mới nhất được công bố.',
                'Các chính sách khác (thanh toán, giao hàng, đổi trả, bảo mật, v.v.) được công bố trên Website là bộ phận không tách rời của điều kiện giao dịch chung này.',
              ],
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Chính sách bảo mật',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHÍNH SÁCH BẢO MẬT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildContentParagraph(
              'GVmarket tôn trọng và cam kết bảo vệ dữ liệu cá nhân của người dùng. '
                  'Chúng tôi áp dụng các biện pháp an toàn và tuân thủ quy định pháp luật hiện hành.',
            ),
            _buildContentSection(
              title: '1. Thông tin được thu thập',
              items: [
                'Thông tin tài khoản: họ tên, email, số điện thoại, địa chỉ.',
                'Dữ liệu truy cập: địa chỉ IP, loại trình duyệt, lịch sử truy cập.',
                'Dữ liệu vị trí: vị trí thiết bị (nếu được cho phép).',
              ],
            ),
            _buildContentSection(
              title: '2. Mục đích sử dụng',
              items: [
                'Cung cấp và duy trì dịch vụ: xử lý đơn hàng và giao dịch.',
                'Cải thiện trải nghiệm người dùng.',
                'Hỗ trợ khách hàng: gửi thông báo, hỗ trợ kỹ thuật.',
                'Bảo mật và an toàn: phát hiện, ngăn chặn hành vi gian lận.',
              ],
            ),
            _buildContentSection(
              title: '3. Bảo mật dữ liệu',
              items: [
                'Giới hạn quyền truy cập: Thông tin chỉ được truy cập bởi nhân sự có thẩm quyền.',
                'Mã hóa dữ liệu: Triển khai chứng chỉ SSL 256-bit.',
                'Quản lý vòng đời dữ liệu: Xóa hoặc ẩn danh thông tin khi không còn cần thiết.',
              ],
            ),
            _buildContentSection(
              title: '4. Quyền của người dùng',
              items: [
                'Xem và chỉnh sửa thông tin cá nhân tại trang Hồ sơ.',
                'Yêu cầu truy cập, chỉnh sửa hoặc xóa dữ liệu cá nhân.',
                'Rút lại sự đồng ý cho việc thu thập, sử dụng dữ liệu.',
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Chính sách này tuân thủ Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân.',
                style: TextStyle(fontSize: 14, height: 1.5, fontStyle: FontStyle.italic),
              ),
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  void _showReturnPolicy(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Chính sách đổi trả',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHÍNH SÁCH ĐỔI, TRẢ & HOÀN TIỀN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text('Thời hạn đổi trả: 07 ngày kể từ ngày nhận hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            _buildContentSection(
              title: '1. Trường hợp được đổi, trả',
              items: [
                'Sản phẩm bị lỗi kỹ thuật từ nhà sản xuất.',
                'Sản phẩm bị hư hỏng trong quá trình vận chuyển.',
                'Sản phẩm hết hạn hoặc sắp hết hạn sử dụng.',
                'Giao sai số lượng, mẫu mã so với đơn hàng.',
              ],
            ),
            _buildContentSection(
              title: '2. Trường hợp KHÔNG được đổi, trả',
              items: [
                'Sản phẩm quà tặng, khuyến mãi.',
                'Quá thời hạn 07 ngày.',
                'Đã sử dụng, bóc tem/niêm phong.',
                'Thiếu/hư hỏng bao bì do lỗi khách hàng.',
              ],
            ),
            _buildContentSection(
              title: '3. Quy trình đổi trả',
              items: [
                'Liên hệ hotline/email thông báo "Yêu cầu đổi trả".',
                'Bộ phận CSKH kiểm tra và hướng dẫn gửi sản phẩm.',
                'Xác nhận tình trạng → Đổi sản phẩm mới hoặc hoàn tiền.',
              ],
              isNumberedList: true,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('⏱️ Thời gian hoàn tiền:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('• Ví điện tử: 3 – 5 ngày làm việc\n• Chuyển khoản: 5 – 7 ngày làm việc', style: TextStyle(fontSize: 14, height: 1.6)),
                ],
              ),
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  void _showPaymentPolicy(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Chính sách thanh toán',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHÍNH SÁCH THANH TOÁN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            _buildContentSection(
              title: '1. Các hình thức thanh toán',
              items: [
                'COD - Thanh toán khi nhận hàng.',
                'Thanh toán trực tuyến: Thẻ ATM, Visa, MasterCard, JCB.',
                'Chuyển khoản ngân hàng.',
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Khi chuyển khoản, ghi rõ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('"Tên – SĐT – Mã đơn hàng"', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.deepOrange)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('⏱️ Thời gian xác nhận:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('• Cùng ngân hàng: 30 phút\n• Khác ngân hàng: 24 giờ', style: TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
            _buildContentSection(
              title: '2. Bảo mật thanh toán',
              items: [
                'Hệ thống tuân thủ chuẩn bảo mật PCI DSS.',
                'Không lưu giữ, tiết lộ thông tin thẻ/tài khoản cho bên thứ ba.',
              ],
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  void _showWarrantyPolicy(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Chính sách bảo hành',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHÍNH SÁCH BẢO HÀNH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sản phẩm còn thời hạn bảo hành sẽ được bảo hành theo tiêu chuẩn của nhà sản xuất.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            _buildContentSection(
              title: 'Trường hợp KHÔNG được bảo hành:',
              items: [
                'Sản phẩm đã hết thời hạn bảo hành.',
                'Hư hỏng do sử dụng không đúng cách.',
                'Hư hỏng do bất khả kháng: lũ lụt, cháy nổ, sét đánh...',
                'Không có hóa đơn mua hàng hợp lệ.',
                'Tự gây hư hỏng, trầy xước sản phẩm.',
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Vui lòng giữ hóa đơn mua hàng để được hỗ trợ bảo hành.', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  void _showShippingPolicy(BuildContext context) {
    _showContentDialog(
      context: context,
      title: 'Chính sách vận chuyển',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHÍNH SÁCH VẬN CHUYỂN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_offer, color: Colors.green, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('MIỄN PHÍ vận chuyển cho đơn từ 1.000.000 VNĐ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ],
              ),
            ),
            _buildContentSection(
              title: '1. Hình thức giao hàng',
              items: [
                'Nhận hàng trực tiếp: Tại cửa hàng hoặc kho.',
                'Giao hàng tận nơi: Hợp tác với đơn vị vận chuyển uy tín.',
                'Giao hàng hỏa tốc: Liên hệ trực tiếp để hỗ trợ.',
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('⏱️ Thời gian giao hàng dự kiến:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 12),
                  Text('• Nội thành HN/HCM: 1 – 2 ngày\n• Các tỉnh khác: 2 – 5 ngày\n• Khu vực xa, hải đảo: 5 – 7 ngày', style: TextStyle(fontSize: 14, height: 1.6)),
                ],
              ),
            ),
            _buildContentSection(
              title: '2. Quy định khi nhận hàng',
              items: [
                'Kiểm tra kỹ tình trạng hàng hóa, số lượng.',
                'Nếu phát hiện lỗi → Từ chối nhận và liên hệ ngay hotline.',
                'Khuyến nghị: Quay video mở hộp để bảo đảm quyền lợi.',
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.videocam, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Khuyến nghị: Quay video mở hộp để bảo đảm quyền lợi!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue)),
                  ),
                ],
              ),
            ),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  // ============================================
  // MAIN CONTENT DIALOG
  // ============================================

  void _showContentDialog({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
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
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
