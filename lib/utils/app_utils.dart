import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static void openUrl(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    );
  }

  static void showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool isDestructive = false,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            message,
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff111526),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              cancelText,
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xffED1C24),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff111526),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showErrorDialog(
    BuildContext context, {
    required String message,
    VoidCallback? callBack,
    bool isDestructive = false,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Text(
            message,
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff111526),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () {
              Navigator.of(context).pop();
              callBack?.call();
            },
            child: Text(
              'Ok',
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff111526),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
