import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Màn hình Profile - Trang NATIVE (không phải WebView)
///
/// Tab "Cá nhân" - Chứa:
/// - Header với logo và tên app
/// - Thông tin công ty
/// - Cài đặt & Pháp lý (6 chính sách)
///
/// Hỗ trợ responsive layout cho cả iPhone và iPad
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
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(AppConstants.companyAddress, style: const TextStyle(fontSize: 14)),
              ),
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
                  'Chúng tôi áp dụng các biện pháp an toàn và tuân thủ quy định pháp luật hiện hành '
                  'nhằm bảo mật thông tin cá nhân mà Quý khách cung cấp.',
            ),
            _buildContentParagraph(
              'Khi truy cập trang web, đăng ký tài khoản hoặc sử dụng dịch vụ của GVmarket, '
                  'Quý khách xác nhận và đồng ý rằng chúng tôi có thể thu thập, sử dụng, tiết lộ và xử lý '
                  'dữ liệu cá nhân theo nội dung của chính sách này. Nếu Quý khách không đồng ý với bất kỳ '
                  'điều khoản nào, vui lòng cân nhắc và ngừng sử dụng dịch vụ của chúng tôi.',
            ),
            _buildContentParagraph(
              'Để đảm bảo phù hợp với thực tế và các yêu cầu pháp luật, GVmarket có thể sửa đổi, bổ sung '
                  'hoặc cập nhật chính sách bảo mật theo từng thời điểm. Mọi thay đổi quan trọng sẽ được '
                  'chúng tôi công bố công khai trên trang web để Quý khách tiện theo dõi.',
            ),
            _buildContentSection(
              title: '1/ Thông tin cá nhân được thu thập',
              items: [
                'Chúng tôi có thể thu thập và lưu trữ một số loại thông tin cá nhân cần thiết nhằm cung cấp dịch vụ tốt nhất cho bạn, bao gồm nhưng không giới hạn ở:',
                'Thông tin tài khoản: họ tên, email, số điện thoại, địa chỉ liên hệ, ảnh hồ sơ.',
                'Dữ liệu truy cập: địa chỉ IP, loại trình duyệt, lịch sử và thời lượng truy cập.',
                'Dữ liệu vị trí: vị trí thiết bị, thông tin định vị kèm theo hình ảnh hoặc video mà Quý khách chia sẻ.',
                'Thông tin khác: dữ liệu Quý khách cung cấp trong quá trình sử dụng dịch vụ (ví dụ: cài đặt tài khoản, sở thích nhận thông tin tiếp thị).',
                'Thông tin tổng hợp: dữ liệu thống kê và phân tích hành vi người dùng nhằm cải thiện trải nghiệm.',
              ],
            ),
            _buildContentSection(
              title: 'Thông tin cá nhân có thể được thu thập trong các trường hợp sau: ',
              items: [
                'Khi Quý khách đăng ký hoặc mở tài khoản.',
                'Khi Quý khách sử dụng các dịch vụ của chúng tôi.',
                'Khi Quý khách tham gia khảo sát, chương trình khuyến mại hoặc sự kiện.',
                'Khi Quý khách gửi phản hồi, khiếu nại hoặc liên hệ trực tiếp với chúng tôi.',
                'Khi Quý khách liên kết tài khoản hoặc chia sẻ thông tin qua mạng xã hội.',
                'Chúng tôi khuyến khích Quý khách cung cấp thông tin chính xác và cập nhật thường xuyên để đảm bảo quyền lợi của mình. Trong một số trường hợp cần thiết, chúng tôi có thể đề nghị Quý khách cung cấp tài liệu xác minh nhằm đảm bảo độ chính xác, an toàn và bảo mật cho tài khoản cũng như dữ liệu cá nhân của Quý khách.',
              ],
            ),
            _buildContentSection(
              title: '2/ Mục đích sử dụng thông tin',
              items: [
                'Chúng tôi cam kết chỉ sử dụng thông tin cá nhân của Quý khách cho những mục đích hợp pháp và cần thiết, bao gồm nhưng không giới hạn ở:',
                'Cung cấp và duy trì dịch vụ: đảm bảo các đơn hàng và giao dịch của Quý khách được xử lý nhanh chóng, chính xác.',
                'Cải thiện trải nghiệm người dùng: nâng cao chất lượng sản phẩm, dịch vụ và tối ưu hóa giao diện, tính năng của trang web.',
                'Hỗ trợ khách hàng: gửi thông báo liên quan đến đơn hàng, hỗ trợ kỹ thuật và giải đáp thắc mắc.',
                'Tiếp thị và khuyến mãi: gửi đến Quý khách thông tin về chương trình ưu đãi, sản phẩm hoặc dịch vụ mới khi Quý khách đồng ý nhận thông tin tiếp thị.',
                'Bảo mật và an toàn: phát hiện, ngăn chặn hành vi gian lận, giả mạo hoặc vi phạm pháp luật.',
                'Tuân thủ pháp luật: thực hiện các nghĩa vụ báo cáo, lưu trữ hoặc cung cấp thông tin theo quy định của pháp luật Việt Nam.',
              ],
            ),
            _buildContentSection(
              title: '3/ Chia sẻ thông tin cá nhân',
              items: [
                'Chúng tôi cam kết không bán, trao đổi hoặc chia sẻ thông tin cá nhân của Quý khách cho bên thứ ba vì mục đích thương mại. Việc chia sẻ thông tin, nếu có, chỉ được thực hiện trong phạm vi cần thiết và phù hợp với quy định pháp luật, nhằm phục vụ việc cung cấp và nâng cao chất lượng dịch vụ. Các bên có thể bao gồm:',
                'Đối tác xử lý và phân tích dữ liệu phục vụ vận hành và cải thiện trải nghiệm người dùng.',
                'Đối tác cung cấp dịch vụ truyền thông như SMS, email hoặc cuộc gọi nhằm gửi thông báo, hỗ trợ kỹ thuật hoặc chăm sóc khách hàng.',
                'Đối tác tiếp thị, chi nhánh và công ty liên kết trong hệ thống để triển khai chương trình ưu đãi, giới thiệu dịch vụ, sản phẩm mới.',
                'Các đơn vị hỗ trợ bảo mật nhằm đảm bảo an toàn, ngăn ngừa gian lận và bảo vệ quyền lợi hợp pháp của khách hàng cũng như của chúng tôi.',
                'Cơ quan nhà nước có thẩm quyền khi có yêu cầu theo quy định pháp luật hiện hành.',
              ],
            ),
            _buildContentParagraph(
              'Chúng tôi cam kết không bán, trao đổi hoặc chia sẻ thông tin cá nhân của Quý khách cho bên thứ ba vì mục đích thương mại.',
            ),
            _buildContentSection(
              title: '4/ Cookie',
              items: [
                'Để mang đến trải nghiệm tốt hơn cho người dùng, chúng tôi sử dụng cookie và các công nghệ tương tự với các mục đích sau:',
                'Lưu trữ thông tin đăng nhập, giúp Quý khách truy cập và sử dụng dịch vụ thuận tiện hơn.',
                'Phân tích dữ liệu truy cập nhằm cải thiện hiệu suất và tối ưu hóa hoạt động của trang web.',
                'Cá nhân hóa nội dung và hiển thị phù hợp với nhu cầu, sở thích của từng người dùng.',
                'Cookie không có khả năng truy cập dữ liệu trên ổ cứng của Quý khách hoặc thu thập thông tin từ các trang web khác. '
              ],
            ),
            _buildContentParagraph(
              'Quý khách có thể quản lý hoặc xóa cookie bất kỳ lúc nào thông qua cài đặt trình duyệt. Tuy nhiên, xin lưu ý rằng việc tắt cookie có thể làm giảm hoặc hạn chế một số tính năng và trải nghiệm khi sử dụng dịch vụ.',
            ),
            _buildContentSection(
              title: '5/ Quyền của người dùng',
              items: [
                'Chúng tôi tôn trọng và bảo vệ quyền lợi hợp pháp của Quý khách đối với dữ liệu cá nhân. Quý khách có thể thực hiện các quyền sau:',
                'Xem và chỉnh sửa thông tin cá nhân trực tiếp tại trang Hồ sơ.',
                'Yêu cầu truy cập, chỉnh sửa hoặc chấm dứt việc sử dụng thông tin cá nhân Quý khách bằng cách liên hệ với chúng tôi qua email hỗ trợ.',
                'Rút lại sự đồng ý cho việc thu thập, sử dụng hoặc chia sẻ dữ liệu cá nhân. Xin lưu ý rằng việc rút lại sự đồng ý có thể ảnh hưởng đến khả năng chúng tôi cung cấp một số dịch vụ cho Quý khách.',
                'Trong một số trường hợp nhất định, chúng tôi có thể từ chối yêu cầu nếu thông tin:',
                'Chỉ được sử dụng cho mục đích phân tích nội bộ và không ảnh hưởng trực tiếp đến quyền lợi của Quý khách.',
                'Liên quan đến việc giải quyết tranh chấp, bảo mật kinh doanh hoặc tuân thủ quy định pháp luật.',
                'Việc cung cấp hoặc xử lý vượt quá khả năng hợp lý về chi phí và nguồn lực so với lợi ích mang lại.',
              ],
            ),
            _buildContentParagraph(
              'Mọi yêu cầu hợp lệ của Quý khách sẽ được xem xét và xử lý trong thời gian sớm nhất có thể, phù hợp với quy định pháp luật hiện hành.',
            ),
            _buildContentSection(
              title: '6/ Bảo mật dữ liệu',
              items: [
                'Chúng tôi cam kết bảo mật thông tin cá nhân của Quý khách và áp dụng nhiều biện pháp kỹ thuật cũng như quản lý để ngăn chặn việc truy cập, sử dụng hoặc tiết lộ trái phép. Cụ thể, chúng tôi thực hiện:',
                'Giới hạn quyền truy cập: Thông tin cá nhân chỉ được truy cập bởi nhân sự có thẩm quyền và trong phạm vi cần thiết để thực hiện công việc.',
                'Ứng dụng công nghệ bảo mật: Sử dụng tường lửa, hệ thống phát hiện xâm nhập và các giải pháp an ninh khác nhằm ngăn chặn hành vi truy cập trái phép.',
                'Mã hóa dữ liệu: Triển khai chứng chỉ SSL 256-bit để bảo vệ dữ liệu trong quá trình truyền tải, đảm bảo thông tin không bị đọc trộm hoặc thay đổi.',
                'Quản lý vòng đời dữ liệu: Xóa hoặc ẩn danh thông tin cá nhân khi không còn cần thiết cho mục đích lưu giữ, trừ khi pháp luật yêu cầu bảo quản lâu hơn.',
                'Đào tạo và giám sát nội bộ: Nhân viên được hướng dẫn về quy trình bảo mật và chịu trách nhiệm tuân thủ chính sách bảo vệ dữ liệu.',
                'Trong trường hợp hệ thống của GVmarket bị tấn công trái phép dẫn đến mất mát hoặc rò rỉ dữ liệu cá nhân, GVmarket sẽ:',
                'Kịp thời thông báo cho cơ quan chức năng có thẩm quyền để điều tra, xử lý.',
                'Chủ động thông tin cho khách hàng bị ảnh hưởng, đồng thời đưa ra biện pháp khắc phục và hỗ trợ cần thiết.',
              ],
            ),
            _buildContentParagraph(
              'Mặc dù chúng tôi nỗ lực tối đa để bảo mật dữ liệu, xin lưu ý rằng không có hệ thống nào đảm bảo an toàn tuyệt đối. Do đó, chúng tôi khuyến nghị Quý khách bảo mật thông tin đăng nhập của mình và thông báo ngay cho chúng tôi nếu phát hiện hành vi truy cập trái phép.',
            ),
            _buildContentSection(
              title: '7/ Thời gian lưu giữ dữ liệu',
              items: [
                'Chúng tôi sẽ lưu giữ thông tin cá nhân của Quý khách trong khoảng thời gian cần thiết để thực hiện các mục đích đã nêu trong chính sách này hoặc trong thời hạn luật pháp quy định. Khi mục đích thu thập không còn phù hợp hoặc hết thời hạn lưu giữ theo quy định, chúng tôi sẽ tiến hành xóa, ẩn danh hoặc hủy bỏ thông tin một cách an toàn, trừ khi có yêu cầu khác từ cơ quan có thẩm quyền.',
              ],
            ),
            _buildContentSection(
              title: '8/ Thay đổi chính sách',
              items: [
                'Chính sách bảo mật này có thể được điều chỉnh, cập nhật hoặc bổ sung theo từng thời điểm để phù hợp với thay đổi trong hoạt động kinh doanh, yêu cầu pháp luật hoặc quy định quản lý mới.',
                'Chính sách này được xây dựng và thực hiện phù hợp với Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân và các quy định pháp luật Việt Nam có liên quan.',
              ],
            ),
            _buildContentParagraph(
              'Mọi sửa đổi sẽ được công bố công khai trên Nền tảng của chúng tôi, và phiên bản cập nhật sẽ có hiệu lực ngay khi được đăng tải. Chúng tôi khuyến khích Quý khách thường xuyên xem lại để nắm rõ cách thức chúng tôi bảo vệ thông tin cá nhân của Quý khách.',
            ),
            _buildContentSection(
              title: '9/ Giải quyết khiếu nại và tranh chấp về dữ liệu cá nhân',
              items: [
                'Trong trường hợp có tranh chấp hoặc khiếu nại liên quan đến việc xử lý dữ liệu cá nhân, GVmarket sẽ tiếp nhận, xem xét và phản hồi trong vòng 15 ngày làm việc kể từ khi nhận được yêu cầu hợp lệ. Trường hợp phức tạp hơn, thời hạn phản hồi có thể kéo dài nhưng không quá 30 ngày làm việc.',
                'Trong trường hợp cần thiết, chúng tôi có thể yêu cầu Quý khách cung cấp thêm tài liệu xác minh để hỗ trợ quá trình xử lý khiếu nại.',
                'Mọi yêu cầu sẽ được xử lý trên tinh thần thiện chí, hợp tác và tuân thủ pháp luật hiện hành nhằm bảo đảm quyền lợi hợp pháp của khách hàng.',
              ],
            ),
            const SizedBox(height: 16),
            const Text('10/ Liên hệ hỗ trợ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildContentParagraph(
              'Nếu Quý khách có bất kỳ câu hỏi, đề nghị truy cập, chỉnh sửa, xóa dữ liệu cá nhân hoặc khiếu nại liên quan đến việc bảo mật thông tin, vui lòng liên hệ với chúng tôi qua địa chỉ sau:',
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Công ty TNHH Brand New K', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_on, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Địa chỉ: 11A đường số 52, KDC Văn Minh, phường Bình Trưng, Thành Phố Hồ Chí Minh', style: TextStyle(fontSize: 14, height: 1.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.email, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('brandnewk.marketing@gmail.com', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.phone, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('028 2211 2280', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Bộ phận phụ trách bảo vệ dữ liệu cá nhân', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.person, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Nguyễn Anh Khoa - Giám đốc', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
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
                children: [
                  const Icon(Icons.access_time, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Thời hạn đổi trả: 07 ngày kể từ ngày nhận hàng',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            _buildContentSection(
              title: '1/ Phạm vi áp dụng',
              items: [
                'Chính sách này được áp dụng cho mọi đơn hàng mua sắm tại GVmarket, bao gồm các hình thức mua trực tuyến trên website, đặt hàng qua điện thoại hoặc mua trực tiếp tại cửa hàng/đại lý chính thức của công ty.​',
              ],
            ),
            _buildContentSection(
              title: '2/ Trường hợp được đổi, trả',
              items: [
                'Sản phẩm bị lỗi kỹ thuật từ nhà sản xuất (thiếu bộ phận, hư hỏng, sai tiêu chuẩn chất lượng).',
                'Sản phẩm gặp tình trạng móp méo, nứt vỡ hoặc trầy xước trong quá trình vận chuyển đến tay Quý khách.',
                'Sản phẩm được giao có hạn sử dụng không đảm bảo (hết hạn hoặc sắp hết hạn).',
                'Sản phẩm giao sai về số lượng, mẫu mã, chủng loại so với đơn hàng.',
                'Lưu ý: Trường hợp đổi trả vì lý do cá nhân (không còn nhu cầu, không thích màu/mẫu, v.v.) sẽ không được áp dụng, ngoại trừ khi sản phẩm vẫn còn nguyên niêm phong, chưa qua sử dụng, và GVmarket đồng ý hỗ trợ trên tinh thần thiện chí. Khi đó, mọi chi phí phát sinh (vận chuyển, xử lý đơn hàng, vật tư đóng gói, v.v.) sẽ do Quý khách chi trả.',
              ],
            ),
            _buildContentSection(
              title: '3/ Trường hợp KHÔNG được đổi, trả',
              items: [
                'Sản phẩm quà tặng, sản phẩm khuyến mãi đặc biệt hoặc sản phẩm được ghi rõ là “không áp dụng đổi trả”.',
                'Sản phẩm đã quá thời hạn đổi trả (07 ngày kể từ ngày nhận hàng).',
                'Sản phẩm đã được sử dụng, có dấu hiệu bóc tem/niêm phong, tháo dỡ.',
                'Sản phẩm bị thiếu hoặc hư hỏng bao bì, tem nhãn, phụ kiện, quà tặng đi kèm do lỗi bảo quản hay tác động từ phía Quý khách.',
                'Sản phẩm có dấu hiệu bị tác động bên ngoài như trầy xước, bám bẩn, ám mùi lạ hoặc hư hỏng do điều kiện bảo quản không phù hợp.',
                'Sản phẩm không mua từ hệ thống chính thức của GVmarket.',
              ],
            ),
            _buildContentSection(
              title: '4/ Điều kiện đổi, trả',
              items: [
                'Sản phẩm phải còn nguyên vẹn, đầy đủ tem nhãn, phụ kiện, quà tặng kèm theo.',
                'Có chứng từ mua hàng hợp lệ (số đơn hàng, hóa đơn, phiếu giao hàng hoặc biên lai thanh toán).',
                'Quý khách cần cung cấp hình ảnh/video mở hộp sản phẩm (nếu sản phẩm lỗi do vận chuyển) để làm căn cứ xử lý khiếu nại.',
              ],
              // isNumberedList: true,
            ),
            _buildContentSection(
              title: '5/ Thời gian đổi, trả',
              items: [
                'Ngay tại thời điểm giao nhận hàng: Quý khách có quyền từ chối nhận nếu phát hiện lỗi.',
                'Thời hạn tiếp nhận yêu cầu: GVmarket chỉ chấp nhận xử lý yêu cầu đổi trả/hoàn tiền trong vòng 07 ngày kể từ ngày Quý khách nhận hàng (ngày nhận hàng được xác định theo dữ liệu từ hệ thống của đơn vị vận chuyển).',
              ],
            ),
            _buildContentSection(
              title: '6/ Quy trình đổi trả',
              items: [
                'Quý khách liên hệ hotline/email để thông báo “Yêu cầu đổi trả” và nêu rõ lý do.',
                'Bộ phận CSKH tiếp nhận, kiểm tra thông tin và hướng dẫn gửi sản phẩm về trung tâm xử lý.',
                'Sau khi nhận sản phẩm và xác nhận tình trạng, GVmarket sẽ tiến hành đổi sản phẩm mới hoặc hoàn tiền theo quy định.',
              ],
            ),
            _buildContentSection(
              title: '7/ Chi phí đổi trả',
              items: [
                'Nếu lỗi từ nhà sản xuất hoặc vận chuyển: GVmarket chịu toàn bộ chi phí đổi trả và giao hàng lại.',
                'Nếu đổi trả do lý do cá nhân/ngoài chính sách: Quý khách chịu chi phí vận chuyển 2 chiều và chi phí phát sinh.',
                'Trường hợp đổi sản phẩm có giá trị cao hơn: Quý khách cần thanh toán thêm phần chênh lệch.',
                'Trường hợp đổi sang sản phẩm khác loại: Sản phẩm muốn đổi phải có giá trị bằng hoặc cao hơn sản phẩm đã mua. Nếu sản phẩm đổi có giá thấp hơn, khoản chênh lệch sẽ không được hoàn lại.',
              ],
            ),
            _buildContentSection(
              title: '8/ Hoàn tiền',
              items: [
                'Nguyên tắc: Việc hoàn tiền được thực hiện theo đúng phương thức thanh toán ban đầu (tiền mặt, chuyển khoản ngân hàng, ví điện tử).',
                'Thời gian xử lý: \n3 – 5 ngày làm việc đối với thanh toán qua ví điện tử/cổng thanh toán.\n5 – 7 ngày làm việc đối với chuyển khoản ngân hàng.\nVới thanh toán quốc tế (Visa/MasterCard), thời gian có thể kéo dài hơn tùy theo quy định của ngân hàng.',
                'GVmarket chỉ tiếp nhận và giải quyết yêu cầu hoàn tiền một lần cho mỗi đơn hàng hợp lệ trong vòng 07 ngày kể từ ngày Quý khách nhận hàng.',
                'Lưu ý: Thời hạn hoàn tiền có thể thay đổi theo quy định của ngân hàng hoặc đối tác thanh toán; trong trường hợp này, GVmarket sẽ chủ động thông báo đến Quý khách.',
                'Với đơn hàng có sử dụng voucher/gift card, GVmarket sẽ hoàn lại bằng voucher/gift card thay vì tiền mặt.',
              ],
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
              title: '1/ Phạm vi áp dụng',
              items: [
                'Chính sách này được áp dụng cho mọi đơn hàng mua sắm tại GVmarket, bao gồm các hình thức mua trực tuyến trên website, đặt hàng qua điện thoại hoặc mua trực tiếp tại cửa hàng/đại lý chính thức của công ty.',
              ],
            ),
            _buildContentSection(
              title: '2/ Các hình thức thanh toán',
              items: [
              ],
            ),
            _buildContentParagraph(
              'a. Thanh toán khi nhận hàng (COD)',
            ),
            _buildContentParagraph(
              '- Quý khách thanh toán trực tiếp cho nhân viên giao hàng khi nhận sản phẩm.\n- Trường hợp giao hàng đến địa chỉ khác với địa chỉ đăng ký, Quý khách cần thanh toán trước toàn bộ giá trị đơn hàng.',
            ),
            _buildContentParagraph(
              'b. Thanh toán trực tuyến qua cổng thanh toán',
            ),
            _buildContentParagraph(
              '- Chúng tôi cung cấp nhiều phương thức:\n - Thẻ ATM nội địa (có đăng ký Internet Banking).\n - Thẻ tín dụng/thẻ ghi nợ quốc tế (Visa, MasterCard, JCB).\n- Quý khách thực hiện thanh toán trực tiếp tại hệ thống trên website khi hoàn tất đặt hàng.\n - Hệ thống thanh toán của GVmarket tuân thủ chuẩn bảo mật PCI DSS, đảm bảo an toàn cho dữ liệu thẻ và thông tin cá nhân.',
            ),
            _buildContentParagraph(
              'c. Chuyển khoản ngân hàng',
            ),
            _buildContentParagraph(
              '- Quý khách có thể thanh toán bằng chuyển khoản tại quầy giao dịch/ATM hoặc Internet Banking.\n - Thông tin chuyển khoản (chủ tài khoản, số tài khoản, ngân hàng) sẽ được hiển thị khi xác nhận đơn hàng.\n - Khi chuyển khoản, Quý khách cần ghi rõ nội dung:\n - “Tên người đặt hàng – Số điện thoại – Mã đơn hàng – Nội dung thanh toán”\n - Sau khi chuyển khoản, Quý khách vui lòng thông báo cho GVmarket qua hotline/email để thuận tiện đối soát.\n- Thời gian xác nhận giao dịch:\n- Cùng ngân hàng: trong vòng 30 phút.\n- Khác ngân hàng: trong vòng 24 giờ.\n- Nếu quá thời gian trên chưa có xác nhận, Quý khách cần liên hệ lại để được hỗ trợ.',
            ),
            _buildContentSection(
              title: '3/ Quy định chung về thanh toán',
              items: [
                'Quý khách có trách nhiệm cung cấp thông tin chính xác khi thực hiện thanh toán, đồng thời lưu giữ hóa đơn/chứng từ (sao kê, biên lai, email xác nhận) để làm căn cứ đối chiếu.',
                'GVmarket không chịu trách nhiệm trong các trường hợp chậm trễ hoặc thất lạc đơn hàng phát sinh từ thông tin thanh toán sai hoặc thiếu.',
                'Với một số đơn hàng đặc biệt (giá trị cao, đặt trước, hoặc giao đến vùng sâu – vùng xa), GVmarket có quyền yêu cầu Quý khách thanh toán trước toàn bộ hoặc một phần giá trị đơn hàng.',
                'Mọi chi phí giao dịch phát sinh từ phía ngân hàng hoặc cổng thanh toán (nếu có) sẽ do Quý khách chịu.',
              ],
            ),
            _buildContentSection(
              title: '4/ Bảo mật thanh toán',
              items: [
                'Thông tin thanh toán của Quý khách được mã hóa và xử lý qua hệ thống bảo mật đạt chuẩn quốc tế.',
                'GVmarket cam kết không lưu giữ, tiết lộ hay chia sẻ thông tin thẻ/tài khoản thanh toán của Quý khách cho bất kỳ bên thứ ba nào, ngoại trừ đối tác thanh toán được ủy quyền và cơ quan có thẩm quyền theo quy định pháp luật.',
              ],
            ),
            _buildContentSection(
              title: '5/ Quyền và nghĩa vụ',
              items: [
              ],
            ),
            _buildContentParagraph(
              '➤ Của GVmarket:',
            ),
            _buildContentSection(
              title: '',
              items: [
                'Cung cấp đầy đủ thông tin, hướng dẫn để Quý khách thực hiện thanh toán chính xác.',
                'Đảm bảo an toàn cho hệ thống thanh toán.',
                'Xác nhận giao dịch và đơn hàng trong thời gian quy định.',
              ],
            ),
            _buildContentParagraph(
              '➤ Của khách hàng:',
            ),
            _buildContentSection(
              title: '',
              items: [
                'Thực hiện thanh toán đúng phương thức, đúng số tiền và đúng thời hạn.',
                'Chủ động thông báo cho GVmarket sau khi chuyển khoản để được xác nhận.',
                'Chịu trách nhiệm về tính hợp pháp của nguồn tiền và thông tin thanh toán đã cung cấp.',
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
            _buildContentSection(
              title: '1/ Những trường hợp sau đây được bảo hành: ',
              items: [
                'Vẫn còn thời hạn bảo hành sẽ được bảo hành theo tiêu chuẩn của nhà sản xuất và theo cam kết mua hàng giữa GVmarket với khách hàng.',
              ],
            ),
            _buildContentSection(
              title: '2/ Những trường hợp sau đây bị từ chối bảo hành : ',
              items: [
                'Sản phẩm đã hết thời hạn bảo hành.',
                'Hư hỏng do người tiêu dùng gây nên hoặc sử dụng không đúng cách theo hướng dẫn sử dụng.',
                'Xảy ra hư hỏng trong một số trường hợp bất khả kháng như: lũ lụt, cháy nổ, động đất, sét đánh trúng…',
                'Không có hóa đơn gốc mua hàng hợp lệ của GVmarket.',
                'Tự gây nên tình trạng hư hỏng, trầy xước sản phẩm.',
              ],
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
              title: '1/ Phạm vi áp dụng',
              items: [
                'Chính sách này được áp dụng cho mọi đơn hàng mua sắm tại GVmarket, bao gồm các hình thức mua trực tuyến trên website, đặt hàng qua điện thoại hoặc mua trực tiếp tại cửa hàng/đại lý chính thức của công ty.',
              ],
            ),
            _buildContentSection(
              title: '2/ Hình thức giao hàng',
              items: [
                'Hiện tại GVmarket giao hàng trên toàn quốc. Một số khu vực đặc biệt (như vùng sâu, vùng xa, hải đảo hoặc nơi khó tiếp cận) có thể phát sinh thêm chi phí và thời gian vận chuyển; khi đó chúng tôi sẽ thông báo trước cho Quý khách. Chúng tôi cung cấp những hình thức giao hàng như sau:',
                'Nhận hàng trực tiếp: Quý khách có thể đến mua và nhận hàng trực tiếp tại cửa hàng hoặc kho của công ty.',
                'Giao hàng tận nơi: Chúng tôi hợp tác với các đơn vị vận chuyển uy tín trên toàn quốc để đảm bảo giao hàng nhanh chóng và an toàn.',
                'Giao hàng hỏa tốc: Với các đơn hàng cần giao gấp, Quý khách vui lòng liên hệ trực tiếp với chúng tôi để được hỗ trợ nhanh chóng.',
                'Lưu ý: Để đảm bảo việc giao nhận được thuận lợi và kịp thời, Quý khách vui lòng nhập đúng và đủ các thông tin theo yêu cầu khi đặt hàng. GVmarket không chịu trách nhiệm nếu phát sinh sự cố giao hàng chậm hoặc thất lạc vì lỗi thông tin cung cấp từ phía Quý khách.',
              ],
            ),
            _buildContentSection(
              title: '3/ Phí vận chuyển',
              items: [
                'Miễn phí vận chuyển cho đơn hàng có giá trị từ 1.000.000 VNĐ trở lên (không áp dụng đồng thời với các chương trình khuyến mãi hoặc giảm giá).',
                'Với các đơn hàng có giá trị dưới mức trên, phí vận chuyển sẽ được tính theo biểu phí của đơn vị vận chuyển tùy thuộc vào địa chỉ nhận hàng, khối lượng và kích thước bưu kiện.',
                'Mức phí cụ thể sẽ được thông báo cho Quý khách trước khi xác nhận đơn hàng.',
                'Trong một số trường hợp đặc biệt (hàng cồng kềnh, hàng dễ vỡ hoặc khu vực xa trung tâm), phí vận chuyển có thể phát sinh thêm và sẽ được thông báo trước cho Quý khách.',
              ],
            ),
            _buildContentSection(
              title: '4/ Thời gian xử lý và giao hàng',
              items: [
                'Đơn hàng được xác nhận sẽ được xử lý trong vòng 24 giờ làm việc.',
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
            _buildContentParagraph(
              'Trong những trường hợp bất khả kháng như thiên tai, dịch bệnh, lưu lượng đơn hàng tăng cao (dịp Lễ/Tết) hoặc lỗi phát sinh ngoài ý muốn, thời gian giao hàng có thể kéo dài hơn. Khi đó, chúng tôi sẽ chủ động thông báo và thỏa thuận lại với Quý khách.',
            ),
            _buildContentSection(
              title: '5/ Quy định khi nhận hàng',
              items: [
                'Quý khách cần kiểm tra kỹ lưỡng tình trạng hàng hóa, số lượng và đối chiếu với đơn hàng đã đặt.',
                'Nếu phát hiện tình trạng sai sản phẩm, thiếu hàng, hư hỏng hoặc dấu hiệu mở niêm phong, Quý khách vui lòng từ chối nhận hàng và liên hệ ngay với bộ phận chăm sóc khách hàng để được hỗ trợ nhanh chóng.',
                'Để bảo đảm quyền lợi, chúng tôi khuyến nghị Quý khách quay video quá trình mở hộp ngay khi nhận hàng. Đây sẽ là cơ sở quan trọng để giải quyết khiếu nại (nếu có).',
                'Trong vòng 24 giờ kể từ khi nhận hàng, nếu phát sinh lỗi liên quan đến vận chuyển, Quý khách cần liên hệ ngay với chúng tôi để được hỗ trợ kịp thời.',
              ],
            ),
            _buildContentSection(
              title: '6/ Trách nhiệm trong quá trình vận chuyển',
              items: [
                'GVmarket chịu trách nhiệm về hàng hóa trong suốt quá trình vận chuyển cho đến khi được giao thành công cho Quý khách.',
                'Sau khi Quý khách ký xác nhận đã nhận hàng, trách nhiệm đối với sản phẩm sẽ được chuyển giao cho Quý khách.',
                'Tất cả đơn hàng đều có mã vận đơn để Quý khách tiện theo dõi trạng thái giao hàng.',
                'Trong trường hợp đơn hàng bị thất lạc hoặc hư hỏng do lỗi vận chuyển, GVmarket sẽ phối hợp với đơn vị vận chuyển để xử lý và đảm bảo quyền lợi của Quý khách.',
              ],
            ),
            _buildContentSection(
              title: '7/ Ngoại lệ và điều khoản đặc biệt',
              items: [
                'Chính sách vận chuyển này không áp dụng cho hàng khuyến mãi, quà tặng hoặc các sản phẩm thuộc chương trình ưu đãi đặc biệt.',
                'Trong cùng một thời điểm, chỉ áp dụng một chính sách khuyến mãi/ưu đãi vận chuyển cao nhất cho đơn hàng.',
                'Chính sách này có thể được điều chỉnh tùy theo từng chương trình bán hàng cụ thể. Mọi thay đổi sẽ được công bố công khai trên website GVmarket.',
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