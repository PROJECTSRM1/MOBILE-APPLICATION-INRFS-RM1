import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../dashboard/investor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController identifierCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Background Image
          Image.asset(
            'assets/images/share1.jpg',
            fit: BoxFit.cover,
          ),

          // 🔹 Dark Overlay
          Container(color: Colors.black.withValues(alpha: 0.4)
),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: 360,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: const Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Investor Login',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),
                        const Text(
                          'Access your investment portfolio',
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 24),

                        // 🔹 Email / Investor ID
                        TextField(
                          controller: identifierCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email or Investor Registration ID',
                            labelStyle:
                                const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor:
                                Colors.white.withValues(alpha: 0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Password
                        TextField(
                          controller: passwordCtrl,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor:
                                Colors.white.withValues(alpha: 0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // 🔹 Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB87A3D),
                              elevation: 6,
                              shadowColor: Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: loading ? null : _login,
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                              child: const Text(
                                'Register here',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 LOGIN API CALL
  Future<void> _login() async {
    final identifier = identifierCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      _showSnack('Please enter all fields');
      return;
    }

    setState(() => loading = true);

    try {
      final res = await AuthService.loginUser(
        identifier: identifier,
        password: password,
      );
 if (!mounted) return; 
      // Adjust keys if backend response differs
      final user = UserModel(
        name: res['name'] ?? '',
        email: res['email'] ?? '',
        mobile: res['mobile'] ?? '',
        customerId: res['inv_reg_id'] ?? '',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InvestorDashboard(user: user),
        ),
      );
    } catch (e) {
  if (!mounted) return;

  final msg = e.toString();

  if (msg.contains('OTP verification required')) {
    _showSnack('Please verify OTP to continue');

    Navigator.pushNamed(
      context,
      AppRoutes.otp,
      arguments: {
        'email': identifierCtrl.text.trim(),
      },
    );
  } else {
    _showSnack('Login failed. Please check your credentials.');
  }
}

     finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
