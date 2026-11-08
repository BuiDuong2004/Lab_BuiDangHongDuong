import 'package:flutter/material.dart';
import 'notification_service.dart';

// KHỐI 1: Điểm bắt đầu của ứng dụng
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo NotificationService trước khi chạy ứng dụng
  await NotificationService.instance.init();

  runApp(const MyApp());
}

// KHỐI 2: Khởi tạo ứng dụng Flutter Material Design
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.5 - Local Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationHomeScreen(),
    );
  }
}

// KHỐI 3: Màn hình chính minh họa chức năng Local Notification
class NotificationHomeScreen extends StatefulWidget {
  const NotificationHomeScreen({super.key});

  @override
  State<NotificationHomeScreen> createState() => _NotificationHomeScreenState();
}

class _NotificationHomeScreenState extends State<NotificationHomeScreen> {
  final TextEditingController _titleController = TextEditingController(
    text: 'Thông báo Lab 10.5',
  );
  final TextEditingController _bodyController = TextEditingController(
    text: 'Đây là thông báo cục bộ được gửi từ ứng dụng Flutter!',
  );

  bool _isGranted = false;
  String _statusMessage = 'Chưa kiểm tra quyền thông báo';
  int _notificationCounter = 1;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  // KHỐI 4: Kiểm tra và yêu cầu quyền gửi thông báo
  Future<void> _checkInitialPermission() async {
    // Tự động yêu cầu quyền lúc mở màn hình (đặc biệt cho Android 13+)
    final granted = await NotificationService.instance.requestPermission();
    if (mounted) {
      setState(() {
        _isGranted = granted;
        _statusMessage = granted
            ? 'Đã được cấp quyền hiển thị thông báo.'
            : 'Chưa được cấp quyền (hoặc người dùng đã từ chối).';      });    }  }
  // Yêu cầu cấp quyền khi bấm nút
  Future<void> _requestPermissionManually() async {
    final granted = await NotificationService.instance.requestPermission();
    if (!mounted) return;
    setState(() {
      _isGranted = granted;
      _statusMessage = granted
          ? 'Đã được cấp quyền thành công!'
          : 'Quyền thông báo bị từ chối.';    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? '✅ Quyền thông báo đã được chấp thuận!'
              : '⚠️ Bạn chưa cho phép ứng dụng gửi thông báo.',
        ),
        backgroundColor: granted ? Colors.green : Colors.orange,
      ),
    );
  }

  // KHỐI 5: Kích hoạt thông báo mặc định
  Future<void> _triggerDefaultNotification() async {
    await NotificationService.instance.showNotification(
      id: _notificationCounter++,
      title: 'Thông báo thử nghiệm 🎉',
      body: 'Xin chào! Bạn vừa kích hoạt thông báo cục bộ thành công.',
      payload: 'demo_payload_default',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi thông báo thử nghiệm đến thanh thông báo!'),
        ),
      );
    }
  }

  // KHỐI 6: Kích hoạt thông báo khi người dùng đăng nhập thành công (Đáp ứng yêu cầu LO7)
  Future<void> _triggerLoginNotification() async {
    await NotificationService.instance
        .showLoginSuccessNotification('Bùi Đăng Hồng Dương');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã giả lập gửi thông báo Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // KHỐI 7: Kích hoạt thông báo khi người dùng đăng xuất
  Future<void> _triggerLogoutNotification() async {
    await NotificationService.instance.showLogoutNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã giả lập gửi thông báo Đăng xuất!'),
          backgroundColor: Colors.blueGrey,
        ),
      );
    }
  }

  // KHỐI 8: Kích hoạt thông báo với nội dung tùy chỉnh
  Future<void> _triggerCustomNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ Tiêu đề và Nội dung!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await NotificationService.instance.showNotification(
      id: _notificationCounter++,
      title: title,
      body: body,
      payload: 'custom_notification_${DateTime.now().millisecondsSinceEpoch}',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi thông báo tùy chỉnh! Hãy kiểm tra thanh thông báo.'),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // KHỐI 9: Giao diện hiển thị
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5 - Local Notification (LO7)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card giới thiệu và trạng thái quyền
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isGranted
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                      size: 54,
                      color: _isGranted ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tích Hợp Local Notification (LO7)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isGranted ? Colors.green[800] : Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _requestPermissionManually,
                      icon: const Icon(Icons.security),
                      label: const Text('Yêu cầu cấp quyền (Android 13+)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card kích hoạt thông báo mẫu
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kích hoạt thông báo mẫu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _triggerDefaultNotification,
                        icon: const Icon(Icons.send),
                        label: const Text('Gửi thông báo mặc định'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _triggerLoginNotification,
                        icon: const Icon(Icons.login, color: Colors.green),
                        label: const Text(
                          'Giả lập: Thông báo Đăng nhập thành công',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _triggerLogoutNotification,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Giả lập: Thông báo Đăng xuất',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card gửi thông báo tùy chỉnh
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gửi thông báo tùy chỉnh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề thông báo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung thông báo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.message),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _triggerCustomNotification,
                        icon: const Icon(Icons.notification_add),
                        label: const Text('Gửi thông báo tùy chỉnh'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card hiển thị phản hồi khi người dùng bấm vào thông báo
            ValueListenableBuilder<String?>(
              valueListenable:
                  NotificationService.instance.selectedNotificationPayload,
              builder: (context, payload, _) {
                if (payload == null) {
                  return const SizedBox.shrink();
                }
                return Card(
                  color: Colors.amber[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.amber.shade400),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bạn vừa mở thông báo có Payload:\n$payload',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Card tóm tắt kiến thức LO7
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '📌 Các bước triển khai LO7:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('1. Thêm package flutter_local_notifications vào pubspec.yaml.'),
                    Text('2. Thêm quyền POST_NOTIFICATIONS vào AndroidManifest.xml (Android 13+).'),
                    Text('3. Khởi tạo AndroidInitializationSettings và NotificationChannel.'),
                    Text('4. Yêu cầu quyền lúc runtime qua requestNotificationsPermission().'),
                    Text('5. Gọi plugin.show() để hiển thị thông báo ngay sau thao tác của người dùng.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
