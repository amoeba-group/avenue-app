import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:avenue/constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../repository/notification_repository.dart';
import '../services/local_storage_service.dart';

class FirebaseMessagingManager {
  NotificationRepository notificationRepository;

  FirebaseMessagingManager(this.notificationRepository) {
    setupFirebaseFCM();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? latestProcessedInitialMessageId;

  Future<void> setupFirebaseFCM() async {
    await initNotificationsSettings();

    // Push Notification arrives when the App is in Opened and in Foreground
    FirebaseMessaging.onMessage.listen((message) {
      handleForegroundNotification(message, false);
    });

    // Push Notification is clicked
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotificationActionFromRemoteMessage(message, true);
    });
  }

  Future<void> initNotificationsSettings() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Config FirebaseMessaging Plugin - Used for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );

    _handleNotificationLocalAndroid();
  }

  void _handleNotificationLocalAndroid() {
    if (Platform.isAndroid) {
      FlutterLocalNotificationsPlugin().initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (res) {
          //res.payload
        },
      );
    }
  }

  Future<void> handleForegroundNotification(
    RemoteMessage message,
    bool isStatusApp,
  ) async {
    try {
      if (Platform.isAndroid && message.data.isNotEmpty) {
        log('NEW NOTIFICATION ${message.data}');
        await showTopPopupNewOrder(message.data);
      }
    } catch (e) {
      log('Error handling foreground notification: $e');
    }
  }

  Future<void> processInitialMessage() async {
    try {
      final RemoteMessage? message = await FirebaseMessaging.instance
          .getInitialMessage();
      if (message != null) {
        if (latestProcessedInitialMessageId == null ||
            latestProcessedInitialMessageId != message.messageId) {
          log('Processing Initial Message');
          latestProcessedInitialMessageId = message.messageId;
          handleNotificationActionFromRemoteMessage(message, true);
        } else {
          log('Initial Message Already Processed');
        }
      }
    } catch (e) {
      log('Error processing initial message: $e');
    }
  }

  void handleNotificationActionFromRemoteMessage(
    RemoteMessage message,
    bool isStatusApp,
  ) {
    try {
      log('NEW NOTIFICATION  ${message.data}');

      final int orderId =
          int.tryParse(message.data["id"]?.toString() ?? "0") ?? 0;
      // if (RouteService().currentPath.value != "/order-detail") {
      //   GetIt.instance.get<EventBus>().fire(OrderDetailEvent(orderId));
      // }
    } catch (e) {
      log('Error handling notification action: $e');
    }
  }

  Future<void> showTopPopupNewOrder(Map<String, dynamic> data) async {
    try {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      final int notificationId =
          int.tryParse(data["id"]?.toString() ?? "0") ?? 0;
      final String title = data["title"]?.toString() ?? "New Notification";
      final String body = data["body"]?.toString() ?? "";

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        payload: notificationId.toString(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'laundry_channel_id',
            'Laundry Notifications',
            channelDescription: 'Notifications for laundry orders',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            // ✅ FIX: Thêm icon nếu có
            // icon: 'app_icon',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  Future<void> deleteToken() => firebaseMessaging.deleteToken();

  Future<String?> getNotificationToken() => firebaseMessaging.getToken();

  /// Register Firebase Token to Server
  Future<void> registerTokenFCM() async {
    try {
      await firebaseMessaging.requestPermission(
        announcement: true,
        sound: true,
        badge: true,
        alert: true,
      );

      final String? firebaseToken = await getNotificationToken();

      if (firebaseToken != null) {
        log('Firebase Token: $firebaseToken');
        final String? deviceToken = await LocalStorageService.read(
          keyDeviceToken,
        );
        //
        if (deviceToken == null || deviceToken != firebaseToken) {
          await notificationRepository.sendDeviceToken(firebaseToken);
          LocalStorageService.save(keyDeviceToken, firebaseToken);
        }
      } else {
        log('Failed to get Firebase token');
      }
    } catch (e) {
      log('Error registering FCM token: $e');
    }
  }

  void dispose() {
    // Clean up any subscriptions if needed
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log("Handling a background message: ${message.messageId}");
  }
}
