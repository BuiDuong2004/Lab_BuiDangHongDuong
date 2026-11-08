
import 'package:flutter/material.dart';

// KHỐI 1: Điểm bắt đầu của ứng dụng Flutter.
void main() {
  runApp(const MyApp());
}

// KHỐI 2: Khởi tạo ứng dụng và giao diện Material Design.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.1 - Mock Login',
      home: const LoginScreen(),
    );
  }
}

// KHỐI 3: Màn hình đăng nhập.
// Dùng StatefulWidget vì màn hình có dữ liệu thay đổi:
// loading, thông báo lỗi và nội dung người dùng nhập.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // KHỐI 4: Quản lý Form và các ô nhập liệu.
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // KHỐI 5: Các trạng thái của màn hình.
  bool _isLoading = false;
  String? _errorMessage;

  // KHỐI 6: Hàm đăng nhập giả lập.
  Future<void> _login() async {
    // Kiểm tra email và password trước.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Giả lập chờ máy chủ xử lý trong 2 giây.
    await Future.delayed(const Duration(seconds: 2));

    // Tài khoản giả lập để kiểm tra.
    // Đây không phải tài khoản của một hệ thống thật.
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (email == 'student@gmail.com' &&
        password == '123456') {
      // Đăng nhập thành công thì chuyển sang Home.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      // Sai tài khoản hoặc mật khẩu thì hiển thị lỗi.
      setState(() {
        _errorMessage = 'Email hoặc mật khẩu không đúng!';
      });
    }
  }

  // KHỐI 7: Giải phóng bộ nhớ của các controller.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // KHỐI 8: Xây dựng giao diện đăng nhập.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 72,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),

                // Ô nhập email.
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }

                    if (!value.contains('@') ||
                        !value.contains('.')) {
                      return 'Email chưa hợp lệ';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Ô nhập mật khẩu.
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }

                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Hiển thị thông báo nếu đăng nhập sai.
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 16),

                // Nút đăng nhập.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Đăng nhập'),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Tài khoản thử: student@gmail.com\n'
                  'Mật khẩu thử: 123456',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// KHỐI 9: Màn hình Home khi đăng nhập thành công.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text(
          'Đăng nhập thành công!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
