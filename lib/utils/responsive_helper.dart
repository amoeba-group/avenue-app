import 'package:flutter/material.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Responsive Helper - Hỗ trợ layout cho cả iPhone và iPad
/// ══════════════════════════════════════════════════════════════════════════════
///
/// Sử dụng shortestSide để phân biệt:
/// - Phone: shortestSide < 600
/// - Tablet (iPad): shortestSide >= 600
///
/// Usage:
///   if (ResponsiveHelper.isTablet(context)) { ... }
///   ResponsiveHelper.contentPadding(context)
///   ResponsiveHelper.maxContentWidth(context)
///
/// ══════════════════════════════════════════════════════════════════════════════
class ResponsiveHelper {
  /// Kiểm tra thiết bị có phải tablet (iPad) không
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// Kiểm tra đang ở chế độ landscape không
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Lấy chiều rộng tối đa cho content
  /// - Phone: full width
  /// - Tablet portrait: 600px max
  /// - Tablet landscape: 800px max
  static double maxContentWidth(BuildContext context) {
    if (!isTablet(context)) return double.infinity;
    return isLandscape(context) ? 800 : 600;
  }

  /// Padding cho content area
  /// - Phone: 16px
  /// - Tablet: 24px
  static EdgeInsets contentPadding(BuildContext context) {
    return EdgeInsets.all(isTablet(context) ? 24 : 16);
  }

  /// Font size scale factor cho tablet
  /// - Phone: 1.0
  /// - Tablet: 1.15
  static double fontScale(BuildContext context) {
    return isTablet(context) ? 1.15 : 1.0;
  }

  /// Icon size cho tablet
  /// - Phone: baseSize
  /// - Tablet: baseSize * 1.2
  static double iconSize(BuildContext context, {double baseSize = 24}) {
    return isTablet(context) ? baseSize * 1.2 : baseSize;
  }

  /// Spacing cho tablet
  /// - Phone: baseSpacing
  /// - Tablet: baseSpacing * 1.5
  static double spacing(BuildContext context, {double baseSpacing = 16}) {
    return isTablet(context) ? baseSpacing * 1.5 : baseSpacing;
  }

  /// Widget wrapper để center content với max width trên iPad
  /// Dùng cho native screens (Contact, Profile)
  static Widget constrainedContent({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    if (!isTablet(context)) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}
