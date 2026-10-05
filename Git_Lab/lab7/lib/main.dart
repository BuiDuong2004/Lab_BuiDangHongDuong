import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// 1. ROOT APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 - Signup Form',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: const SignupScreen(),
    );
  }
}

// ============================================================
// 2. SIGNUP SCREEN
// ============================================================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// ============================================================
// 3. STATE OF SIGNUP SCREEN
// ============================================================

class _SignupScreenState extends State<SignupScreen> {
  // ----------------------------------------------------------
  // FORM KEY
  // ----------------------------------------------------------

  final _formKey = GlobalKey<FormState>();

  // ----------------------------------------------------------
  // TEXT CONTROLLERS
  // ----------------------------------------------------------

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ----------------------------------------------------------
  // FOCUS NODES
  // ----------------------------------------------------------

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // ----------------------------------------------------------
  // OTHER STATE
  // ----------------------------------------------------------

  bool _isCheckingEmail = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  // ==========================================================
  // VALIDATORS
  // ==========================================================

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ==========================================================
  // SUBMIT
  // ==========================================================

  Future<void> _submit() async {
    // --------------------------------------------------------
    // STEP 1:
    // Validate all fields
    // --------------------------------------------------------

    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // --------------------------------------------------------
    // STEP 2:
    // Hide keyboard
    // --------------------------------------------------------

    FocusScope.of(context).unfocus();

    // --------------------------------------------------------
    // STEP 3:
    // Start async email checking
    // --------------------------------------------------------

    setState(() {
      _isCheckingEmail = true;
    });

    // --------------------------------------------------------
    // STEP 4:
    // Fake API request
    // --------------------------------------------------------

    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim().toLowerCase();

    // --------------------------------------------------------
    // STEP 5:
    // Fake "email already taken" rule
    // --------------------------------------------------------

    if (email.startsWith('taken')) {
      if (!mounted) return;

      setState(() {
        _isCheckingEmail = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already taken')),
      );

      return;
    }

    // --------------------------------------------------------
    // STEP 6:
    // Successful registration
    // --------------------------------------------------------

    if (!mounted) return;

    setState(() {
      _isCheckingEmail = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Signup successful!')));
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------

      appBar: AppBar(title: const Text('Signup'), centerTitle: true),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------
      body: GestureDetector(
        // Tap outside TextField -> hide keyboard
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SafeArea(
          child: Form(
            key: _formKey,

            // Validate while user interacts with fields
            autovalidateMode: AutovalidateMode.onUserInteraction,

            child: ListView(
              padding: const EdgeInsets.all(20),

              children: [
                // =================================================
                // TITLE
                // =================================================

                const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Please fill in the information below.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // =================================================
                // FULL NAME
                // =================================================
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,

                  textInputAction: TextInputAction.next,

                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),

                  validator: _validateName,

                  onFieldSubmitted: (_) {
                    _emailFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 18),

                // =================================================
                // EMAIL
                // =================================================
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,

                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,

                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),

                  validator: _validateEmail,

                  onFieldSubmitted: (_) {
                    _passwordFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 18),

                // =================================================
                // PASSWORD
                // =================================================
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,

                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 8 characters + 1 digit',
                    prefixIcon: const Icon(Icons.lock),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),

                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),

                    border: const OutlineInputBorder(),
                  ),

                  validator: _validatePassword,

                  onFieldSubmitted: (_) {
                    _confirmPasswordFocus.requestFocus();
                  },
                ),

                const SizedBox(height: 18),

                // =================================================
                // CONFIRM PASSWORD
                // =================================================
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,

                  obscureText: !_showConfirmPassword,
                  textInputAction: TextInputAction.done,

                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Enter password again',
                    prefixIcon: const Icon(Icons.lock_outline),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),

                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),

                    border: const OutlineInputBorder(),
                  ),

                  validator: _validateConfirmPassword,

                  onFieldSubmitted: (_) {
                    _submit();
                  },
                ),

                const SizedBox(height: 30),

                // =================================================
                // SUBMIT BUTTON
                // =================================================
                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _isCheckingEmail ? null : _submit,

                    child: _isCheckingEmail
                        ? const SizedBox(
                            width: 24,
                            height: 24,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
