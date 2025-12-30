import 'dart:ui';

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/otp_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;
  bool loading = false;

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  /* ---------------- REGISTER ---------------- */

  Future<void> _register() async {
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showSnack('Passwords do not match');
      return;
    }

    if (!agree) {
      _showSnack('Please accept Terms & Conditions');
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.registerUser(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        mobile: mobileCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      _showSnack(res['message'] ?? 'OTP sent to your email');

      // 👉 NAVIGATE TO OTP SCREEN WITH EMAIL
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            email: emailCtrl.text.trim(),
          ),
        ),
      );
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  /* ---------------- UI ---------------- */

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
          Container(color:Colors.black.withValues(alpha: 0.4)
),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: 380,
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
                        const Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _glassField(
                          controller: firstNameCtrl,
                          label: 'First Name',
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: lastNameCtrl,
                          label: 'Last Name',
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: emailCtrl,
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: mobileCtrl,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: passwordCtrl,
                          label: 'Password',
                          obscure: true,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: confirmPasswordCtrl,
                          label: 'Confirm Password',
                          obscure: true,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: agree,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              onChanged: (v) {
                                setState(() => agree = v ?? false);
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'I agree to the Terms & Conditions and Privacy Policy',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                                agree && !loading ? _register : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFB87A3D),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
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
                                    'Register & Verify',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Login here',
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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // 🔹 Glass TextField
  Widget _glassField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
