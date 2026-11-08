import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'notification_service.dart';

// ============================================================================
// KHỐI 1: KHỞI ĐỘNG ỨNG DỤNG VÀ CÁC DỊCH VỤ NỀN TẢNG
// ============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Khởi tạo Google Sign-In trên nền tảng di động
  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize();
  }

  // 3. Khởi tạo Local Notification (LO7)
  await NotificationService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10 Full - Auth & Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================================
// KHỐI 2: MODEL LƯU TRỮ PHIÊN LÀM VIỆC CỦA NGƯỜI DÙNG (USER SESSION)
// ============================================================================
class UserSession {
  final String authType; // 'api' (DummyJSON) hoặc 'google' (Firebase)
  final String username;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String? token;

  const UserSession({
    required this.authType,
    required this.username,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.token,
  });
}

// ============================================================================
// KHỐI 3: SPLASH SCREEN & AUTO-LOGIN (ĐIỀU HƯỚNG TỰ ĐỘNG)
// ============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Yêu cầu quyền thông báo ngay từ đầu để sẵn sàng hiển thị thông báo
    await NotificationService.instance.requestPermission();

    // Chờ 1.5 giây tạo trải nghiệm Splash Screen mượt mà
    await Future.delayed(const Duration(milliseconds: 1500));

    // 1. Kiểm tra phiên Firebase Authentication (Google Sign-In)
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (!mounted) return;
      final session = UserSession(
        authType: 'google',
        username: currentUser.displayName ?? 'Google User',
        displayName: currentUser.displayName ?? 'Người dùng Google',
        email: currentUser.email ?? '',
        avatarUrl: currentUser.photoURL,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(session: session)),
      );
      return;
    }

    // 2. Kiểm tra phiên REST API đã lưu trong SharedPreferences (Lab 10.3)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      final session = UserSession(
        authType: prefs.getString('auth_type') ?? 'api',
        username: prefs.getString('auth_username') ?? 'User',
        displayName:
            prefs.getString('auth_display_name') ?? 'Người dùng API',
        email: prefs.getString('auth_email') ?? '',
        avatarUrl: prefs.getString('auth_avatar'),
        token: token,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(session: session)),
      );
      return;
    }

    // 3. Nếu chưa đăng nhập thì chuyển đến LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield_outlined, size: 84, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Lab 10 - Final Project',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Authentication & Local Notification',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// KHỐI 4: MÀN HÌNH ĐĂNG NHẬP (TÍCH HỢP REST API + GOOGLE SIGN-IN)
// ============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  bool _isPasswordVisible = false;
  bool _isLoadingApi = false;
  bool _isLoadingGoogle = false;
  String? _errorMessage;

  // --------------------------------------------------------------------------
  // XỬ LÝ ĐĂNG NHẬP QUA REST API (DUMMYJSON)
  // --------------------------------------------------------------------------
  Future<void> _loginWithApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoadingApi = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'expiresInMins': 30,
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final token = data['accessToken'] as String? ?? '';
        final username = data['username'] as String? ?? '';
        final firstName = data['firstName'] as String? ?? '';
        final lastName = data['lastName'] as String? ?? '';
        final displayName = '$firstName $lastName'.trim().isEmpty
            ? username
            : '$firstName $lastName'.trim();
        final email = data['email'] as String? ?? '';
        final avatar = data['image'] as String? ?? '';

        // Lưu phiên đăng nhập vào SharedPreferences (Auto-login)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('auth_type', 'api');
        await prefs.setString('auth_username', username);
        await prefs.setString('auth_display_name', displayName);
        await prefs.setString('auth_email', email);
        await prefs.setString('auth_avatar', avatar);

        // KÍCH HOẠT LOCAL NOTIFICATION KHI ĐĂNG NHẬP THÀNH CÔNG (LO7)
        await NotificationService.instance
            .showLoginSuccessNotification(displayName);

        if (!mounted) return;

        final session = UserSession(
          authType: 'api',
          username: username,
          displayName: displayName,
          email: email,
          avatarUrl: avatar,
          token: token,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(session: session)),
        );
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Đăng nhập API thất bại!';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi kết nối máy chủ. Hãy kiểm tra Internet!';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingApi = false);
      }
    }
  }

  // --------------------------------------------------------------------------
  // XỬ LÝ ĐĂNG NHẬP QUA FIREBASE GOOGLE SIGN-IN
  // --------------------------------------------------------------------------
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
      _errorMessage = null;
    });

    try {
      late final UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final googleUser = await GoogleSignIn.instance.authenticate();
        final credential = GoogleAuthProvider.credential(
          idToken: googleUser.authentication.idToken,
        );
        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Không lấy được thông tin tài khoản Google');
      }

      final displayName = user.displayName ?? 'Google User';
      final email = user.email ?? '';
      final avatar = user.photoURL ?? '';

      // Lưu trạng thái phiên Google
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_type', 'google');
      await prefs.setString('auth_username', displayName);
      await prefs.setString('auth_display_name', displayName);
      await prefs.setString('auth_email', email);
      await prefs.setString('auth_avatar', avatar);

      // KÍCH HOẠT LOCAL NOTIFICATION KHI ĐĂNG NHẬP GOOGLE THÀNH CÔNG (LO7)
      await NotificationService.instance
          .showLoginSuccessNotification(displayName);

      if (!mounted) return;

      final session = UserSession(
        authType: 'google',
        username: displayName,
        displayName: displayName,
        email: email,
        avatarUrl: avatar,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(session: session)),
      );
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled && mounted) {
        setState(() => _errorMessage = 'Lỗi Google Sign-In: $e');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Lỗi đăng nhập Google: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingGoogle = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isLoadingApi || _isLoadingGoogle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập - Lab 10 Full'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chào mừng bạn!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Đăng nhập bằng tài khoản DummyJSON hoặc Google',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Ô nhập Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập (Username)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập Username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ô nhập Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu (Password)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Vui lòng nhập Mật khẩu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Hiển thị thông báo lỗi
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Nút Đăng nhập REST API
                  FilledButton.icon(
                    onPressed: isBusy ? null : _loginWithApi,
                    icon: _isLoadingApi
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.login),
                    label: Text(
                      _isLoadingApi ? 'Đang xác thực...' : 'Đăng nhập (REST API)',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Gợi ý tài khoản test API
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '💡 Tài khoản API DummyJSON mẫu:\n'
                      'Username: emilys  |  Password: emilyspass',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('HOẶC', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Nút Đăng nhập Firebase Google
                  OutlinedButton.icon(
                    onPressed: isBusy ? null : _loginWithGoogle,
                    icon: _isLoadingGoogle
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.g_mobiledata, size: 28),
                    label: Text(
                      _isLoadingGoogle
                          ? 'Đang kết nối Google...'
                          : 'Đăng nhập bằng Google',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// KHỐI 5: MÀN HÌNH CHÍNH (HOME SCREEN) & ĐĂNG XUẤT + THÔNG BÁO (LO7)
// ============================================================================
class HomeScreen extends StatelessWidget {
  final UserSession session;

  const HomeScreen({super.key, required this.session});

  // --------------------------------------------------------------------------
  // XỬ LÝ ĐĂNG XUẤT (CLEAR SESSION + SIGNOUT + LOCAL NOTIFICATION)
  // --------------------------------------------------------------------------
  Future<void> _logout(BuildContext context) async {
    // 1. Xóa dữ liệu phiên trong SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 2. Đăng xuất khỏi Firebase và Google (nếu có)
    try {
      await FirebaseAuth.instance.signOut();
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (e) {
      debugPrint('Lỗi đăng xuất Firebase: $e');
    }

    // 3. KÍCH HOẠT LOCAL NOTIFICATION KHI ĐĂNG XUẤT (LO7)
    await NotificationService.instance.showLogoutNotification();

    if (!context.mounted) return;

    // 4. Quay về LoginScreen và xóa toàn bộ ngăn xếp route
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // --------------------------------------------------------------------------
  // HÀM GỬI THÔNG BÁO THỬ NGHIỆM TRỰC TIẾP TRÊN HOME (LO7)
  // --------------------------------------------------------------------------
  Future<void> _sendTestNotification(BuildContext context) async {
    await NotificationService.instance.showNotification(
      id: 201,
      title: 'Thông báo từ Lab 10 Full 🚀',
      body: 'Xin chào ${session.displayName}, tính năng Notification hoạt động xuất sắc!',
      payload: 'home_test_payload',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi thông báo kiểm tra LO7 lên thanh trạng thái!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = session.authType == 'google';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ - Lab 10 Full'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar người dùng
                CircleAvatar(
                  radius: 48,
                  backgroundColor: isGoogle ? Colors.red[100] : Colors.blue[100],
                  backgroundImage: (session.avatarUrl != null &&
                          session.avatarUrl!.isNotEmpty)
                      ? NetworkImage(session.avatarUrl!)
                      : null,
                  child: (session.avatarUrl == null ||
                          session.avatarUrl!.isEmpty)
                      ? Icon(
                          isGoogle ? Icons.g_mobiledata : Icons.person,
                          size: 50,
                          color: isGoogle ? Colors.red : Colors.blue,
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Tên hiển thị
                Text(
                  'Xin chào, ${session.displayName}!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // Email
                if (session.email.isNotEmpty)
                  Text(
                    session.email,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                const SizedBox(height: 12),

                // Badge phương thức đăng nhập
                Chip(
                  avatar: Icon(
                    isGoogle ? Icons.cloud_done : Icons.api,
                    size: 18,
                    color: isGoogle ? Colors.red : Colors.blue,
                  ),
                  label: Text(
                    isGoogle
                        ? 'Đăng nhập bằng Firebase Google'
                        : 'Đăng nhập bằng REST API (DummyJSON)',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor:
                      isGoogle ? Colors.red.shade50 : Colors.blue.shade50,
                ),

                const SizedBox(height: 24),

                // Thẻ thông tin phiên làm việc
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.badge, color: Colors.blue),
                          title: const Text('Username / ID'),
                          subtitle: Text(session.username),
                        ),
                        const Divider(),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.vpn_key, color: Colors.green),
                          title: const Text('Trạng thái Token / Phiên'),
                          subtitle: Text(
                            isGoogle
                                ? 'Phiên Firebase Auth hoạt động'
                                : 'Đã nhận access token (Lưu SharedPreferences)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Nút kích hoạt thông báo thử nghiệm trực tiếp (LO7)
                FilledButton.tonalIcon(
                  onPressed: () => _sendTestNotification(context),
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Gửi thông báo kiểm tra (LO7)'),
                ),

                const SizedBox(height: 12),

                // Nút Đăng xuất
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất tài khoản'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
