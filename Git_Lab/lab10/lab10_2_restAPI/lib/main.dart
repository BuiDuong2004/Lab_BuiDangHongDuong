
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// KHỐI 1: Khởi tạo ứng dụng.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// KHỐI 2: Màn hình đăng nhập bằng REST API.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // KHỐI 3: Gửi yêu cầu POST đến DummyJSON.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
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

      // Chuyển JSON trả về thành Map của Dart.
      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        // KHỐI 4: Đọc token từ phản hồi API.
        final token = data['accessToken'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              username: data['username'] ?? 'User',
              token: token ?? '',
            ),
          ),
        );
      } else {
        // API có thể trả lỗi khi thông tin đăng nhập sai.
        setState(() {
          _errorMessage =
              data['message'] ?? 'Đăng nhập thất bại';
        });
      }
    } catch (e) {
      // Lỗi mạng, không kết nối được hoặc phản hồi không hợp lệ.
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi kết nối. Hãy kiểm tra Internet.';
        });
      }
    } finally {
      // Dù thành công hay thất bại cũng tắt trạng thái loading.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // KHỐI 5: Giải phóng controller.
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // KHỐI 6: Giao diện nhập username và password.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real API Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Nhập username'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Nhập password'
                          : null,
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Đăng nhập'),
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

// KHỐI 7: Hiển thị kết quả đăng nhập.
class HomeScreen extends StatelessWidget {
  final String username;
  final String token;

  const HomeScreen({
    super.key,
    required this.username,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Xin chào $username!',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Text('Đăng nhập API thành công.'),
              // Chỉ hiển thị trạng thái token, không in token ra màn hình.
              Text('Đã nhận token: ${token.isNotEmpty ? "Có" : "Không"}'),
            ],
          ),
        ),
      ),
    );
  }
}
