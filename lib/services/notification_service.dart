/// Service quản lý Push Notification
/// 
/// LƯU Ý: Để sử dụng push notification, bạn cần:
/// 1. Tạo project Firebase tại https://console.firebase.google.com
/// 2. Thêm app iOS và Android vào Firebase project
/// 3. Download file cấu hình:
///    - iOS: GoogleService-Info.plist → đặt vào ios/Runner/
///    - Android: google-services.json → đặt vào android/app/
/// 4. Uncomment các dependencies firebase trong pubspec.yaml
/// 5. Chạy `flutter pub get`
/// 
/// Đây là placeholder service, uncomment code bên dưới khi đã cấu hình Firebase

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Khởi tạo notification service
  Future<void> initialize() async {
    // ============================================
    // UNCOMMENT CODE BÊN DƯỚI KHI ĐÃ CẤU HÌNH FIREBASE
    // ============================================
    
    /*
    // Khởi tạo Firebase
    await Firebase.initializeApp();
    
    // Lấy instance của Firebase Messaging
    final messaging = FirebaseMessaging.instance;
    
    // Yêu cầu quyền notification (iOS)
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('Notification permission: ${settings.authorizationStatus}');
    
    // Lấy FCM token
    final token = await messaging.getToken();
    print('FCM Token: $token');
    // TODO: Gửi token này lên server của bạn
    
    // Xử lý notification khi app đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận notification: ${message.notification?.title}');
      // TODO: Hiển thị local notification hoặc xử lý
    });
    
    // Xử lý khi tap vào notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Tap notification: ${message.notification?.title}');
      // TODO: Navigate đến màn hình tương ứng
    });
    */
    
    print('NotificationService initialized (placeholder)');
  }

  /// Đăng ký nhận notification cho topic
  Future<void> subscribeToTopic(String topic) async {
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  /// Hủy đăng ký topic
  Future<void> unsubscribeFromTopic(String topic) async {
    // await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}
