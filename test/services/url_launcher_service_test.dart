import 'package:flutter_test/flutter_test.dart';
import 'package:avenue/services/url_launcher_service.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Unit Tests cho URLLauncherService
/// ══════════════════════════════════════════════════════════════════════════════
void main() {
  group('URLLauncherService', () {
    late URLLauncherService service;

    setUp(() {
      service = URLLauncherService();
    });

    group('getURLScheme', () {
      test('should return correct scheme for http URL', () {
        // Arrange
        const url = 'http://example.com';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, 'http');
      });

      test('should return correct scheme for https URL', () {
        // Arrange
        const url = 'https://example.com';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, 'https');
      });

      test('should return correct scheme for tel URL', () {
        // Arrange
        const url = 'tel:0123456789';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, 'tel');
      });

      test('should return correct scheme for mailto URL', () {
        // Arrange
        const url = 'mailto:test@example.com';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, 'mailto');
      });

      test('should return correct scheme for sms URL', () {
        // Arrange
        const url = 'sms:0123456789';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, 'sms');
      });

      test('should return null for invalid URL', () {
        // Arrange
        const url = 'not a valid url';

        // Act
        final scheme = service.getURLScheme(url);

        // Assert
        expect(scheme, null);
      });
    });

    group('isExternalLink', () {
      test('should return true for external link', () {
        // Arrange
        const url = 'https://facebook.com/page';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, true);
      });

      test('should return false for internal link', () {
        // Arrange
        const url = 'https://gvmarket.vn/shop';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, false);
      });

      test('should return false for internal subdomain', () {
        // Arrange
        const url = 'https://www.gvmarket.vn/product/123';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, false);
      });

      test('should return false for empty host', () {
        // Arrange
        const url = 'javascript:void(0)';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, false);
      });

      test('should return false for relative URL', () {
        // Arrange
        const url = '/shop/product/123';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, false);
      });

      test('should return true for TikTok URL', () {
        // Arrange
        const url = 'https://www.tiktok.com/@gvmarket.vn';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, true);
      });

      test('should return true for Facebook URL', () {
        // Arrange
        const url = 'https://www.facebook.com/GVmarket.Vietnam';
        const mainDomain = 'gvmarket.vn';

        // Act
        final result = service.isExternalLink(url, mainDomain);

        // Assert
        expect(result, true);
      });
    });

    group('Launch URL Methods (Platform-dependent)', () {
      test('launchURL should be callable', () async {
        // Note: Actual launch requires platform bindings
        // This test just verifies the method is callable
        expect(
          () => service.launchURL('https://example.com'),
          returnsNormally,
        );
      }, skip: 'Requires platform bindings (integration test)');

      test('launchPhone should be callable', () async {
        expect(
          () => service.launchPhone('0123456789'),
          returnsNormally,
        );
      }, skip: 'Requires platform bindings (integration test)');

      test('launchEmail should be callable', () async {
        expect(
          () => service.launchEmail('test@example.com'),
          returnsNormally,
        );
      }, skip: 'Requires platform bindings (integration test)');

      test('launchSMS should be callable', () async {
        expect(
          () => service.launchSMS('0123456789'),
          returnsNormally,
        );
      }, skip: 'Requires platform bindings (integration test)');

      test('canLaunch should be callable', () async {
        expect(
          () => service.canLaunch('https://example.com'),
          returnsNormally,
        );
      }, skip: 'Requires platform bindings (integration test)');
    });

    group('URL Construction', () {
      test('should construct tel URL correctly', () {
        // Phone URL format is: tel:number
        const phoneNumber = '0123456789';
        final expectedUrl = 'tel:$phoneNumber';

        // Verify the format is correct by parsing
        final uri = Uri.parse(expectedUrl);
        expect(uri.scheme, 'tel');
        expect(uri.path, phoneNumber);
      });

      test('should construct mailto URL correctly', () {
        // Mailto URL format is: mailto:email?subject=...&body=...
        const email = 'test@example.com';
        const subject = 'Test Subject';
        const body = 'Test Body';

        final uri = Uri(
          scheme: 'mailto',
          path: email,
          queryParameters: {
            'subject': subject,
            'body': body,
          },
        );

        expect(uri.scheme, 'mailto');
        expect(uri.path, email);
        expect(uri.queryParameters['subject'], subject);
        expect(uri.queryParameters['body'], body);
      });

      test('should construct sms URL correctly', () {
        // SMS URL format is: sms:number?body=...
        const phoneNumber = '0123456789';
        const body = 'Hello';

        final uri = Uri(
          scheme: 'sms',
          path: phoneNumber,
          queryParameters: {
            'body': body,
          },
        );

        expect(uri.scheme, 'sms');
        expect(uri.path, phoneNumber);
        expect(uri.queryParameters['body'], body);
      });
    });

    group('Edge Cases', () {
      test('should handle null or empty strings gracefully', () {
        // Test with empty string
        expect(service.getURLScheme(''), null);

        // Test isExternalLink with empty URL
        expect(service.isExternalLink('', 'gvmarket.vn'), false);
      });

      test('should handle malformed URLs', () {
        const malformedUrl = 'http://[invalid';

        // Should not throw exception
        expect(
          () => service.getURLScheme(malformedUrl),
          returnsNormally,
        );

        expect(
          () => service.isExternalLink(malformedUrl, 'gvmarket.vn'),
          returnsNormally,
        );
      });

      test('should handle URLs with ports', () {
        const url = 'https://gvmarket.vn:8080/shop';
        const mainDomain = 'gvmarket.vn';

        final result = service.isExternalLink(url, mainDomain);

        expect(result, false);
      });

      test('should handle URLs with query parameters', () {
        const url = 'https://gvmarket.vn/shop?category=electronics&sort=price';
        const mainDomain = 'gvmarket.vn';

        final result = service.isExternalLink(url, mainDomain);

        expect(result, false);
      });

      test('should handle URLs with fragments', () {
        const url = 'https://gvmarket.vn/product/123#reviews';
        const mainDomain = 'gvmarket.vn';

        final result = service.isExternalLink(url, mainDomain);

        expect(result, false);
      });
    });
  });
}
