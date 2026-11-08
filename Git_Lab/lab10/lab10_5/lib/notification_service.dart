import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Biến lưu trạng thái cấp quyền thông báo
  final ValueNotifier<bool> isPermissionGranted = ValueNotifier<bool>(false);
  // Biến lưu trữ payload của thông báo vừa được bấm vào
  final ValueNotifier<String?> selectedNotificationPayload =
      ValueNotifier<String?>(null);
  // ID kênh và tên kênh thông báo trên Android
  static const String channelId = 'lab10_notification_channel';
  static const String channelName = 'Lab 10 Notifications';
  static const String channelDescription =
      'Kênh nhận thông báo các sự kiện trong Lab 10';
  /// Khởi tạo cấu hình cho FlutterLocalNotificationsPlugin
  Future<void> init() async {
    // 1. Cấu hình icon thông báo trên Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 2. Cấu hình cho iOS / macOS
    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // 3. Gom cấu hình chung
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    // 4. Khởi tạo plugin và gán callback khi người dùng bấm vào thông báo
    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Người dùng bấm vào thông báo: ${response.payload}');
          selectedNotificationPayload.value = response.payload;
        },
      );
    } catch (e) {
      debugPrint('Lỗi khởi tạo Notification Plugin: $e');
    }

    // 5. Tạo Notification Channel trên Android (Android 8.0+)
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final AndroidNotificationChannel channel = const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.createNotificationChannel(channel);
    }
  }

  /// Yêu cầu người dùng cấp quyền hiển thị thông báo
  Future<bool> requestPermission() async {
    bool granted = false;

    if (kIsWeb) {
      isPermissionGranted.value = true;
      return true;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Xin quyền POST_NOTIFICATIONS trên Android 13+
      final bool? result =
          await androidImplementation?.requestNotificationsPermission();
      granted = result ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      final bool? result = await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
    }

    isPermissionGranted.value = granted;
    return granted;
  }

  /// Hiển thị thông báo ngay lập tức
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload ?? 'Payload mặc định: id=$id',
      );
    } catch (e) {
      debugPrint('Thông báo: $title - $body (chi tiết: $e)');
    }
  }

  /// Hiển thị thông báo khi đăng nhập thành công (Đáp ứng yêu cầu bài Lab)
  Future<void> showLoginSuccessNotification(String username) async {
    await showNotification(
      id: 101,
      title: 'Đăng nhập thành công! 🎉',
      body: 'Chào mừng $username đã đăng nhập vào hệ thống.',
      payload: 'login_success:$username',
    );
  }

  /// Hiển thị thông báo khi đăng xuất
  Future<void> showLogoutNotification() async {
    await showNotification(
      id: 102,
      title: 'Đã đăng xuất 👋',
      body: 'Bạn đã đăng xuất tài khoản an toàn.',
      payload: 'logout_success',
    );
  }
}
