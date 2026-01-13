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

  /* ---------------- VALIDATION ---------------- */

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validateMobile(String mobile) {
    if (mobile.isEmpty) return 'Mobile number is required';
    if (mobile.length < 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /* ---------------- REGISTER ---------------- */

  Future<void> _register() async {
    // Validation
    final emailError = _validateEmail(emailCtrl.text.trim());
    if (emailError != null) {
      _showSnack(emailError);
      return;
    }

    final mobileError = _validateMobile(mobileCtrl.text.trim());
    if (mobileError != null) {
      _showSnack(mobileError);
      return;
    }

    final passwordError = _validatePassword(passwordCtrl.text.trim());
    if (passwordError != null) {
      _showSnack(passwordError);
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showSnack('Passwords do not match');
      return;
    }

    if (firstNameCtrl.text.trim().isEmpty) {
      _showSnack('First name is required');
      return;
    }

    if (lastNameCtrl.text.trim().isEmpty) {
      _showSnack('Last name is required');
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
        // role_id is set to 1 by default in the backend for investors
      );

      if (!mounted) return;

      _showSnack(
        res['message'] ?? 'OTP sent to your email. Please check your inbox.',
        success: true,
      );

      // 👉 NAVIGATE TO OTP SCREEN WITH EMAIL
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            email: emailCtrl.text.trim(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack(
        e.toString().replaceAll('Exception: ', ''),
        success: false,
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
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
          Container(
            color: Colors.black.withValues(alpha: 0.4),
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
                        // Header Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_add,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Join us as an investor',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _glassField(
                          controller: firstNameCtrl,
                          label: 'First Name',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: lastNameCtrl,
                          label: 'Last Name',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: emailCtrl,
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: mobileCtrl,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: passwordCtrl,
                          label: 'Password',
                          obscure: true,
                          icon: Icons.lock_outline,
                        ),

                        const SizedBox(height: 14),

                        _glassField(
                          controller: confirmPasswordCtrl,
                          label: 'Confirm Password',
                          obscure: true,
                          icon: Icons.lock_outline,
                        ),

                        const SizedBox(height: 16),

                        // Terms & Conditions Checkbox
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: agree,
                                activeColor: const Color(0xFFB87A3D),
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white70,
                                  width: 2,
                                ),
                                onChanged: (v) {
                                  setState(() => agree = v ?? false);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
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

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: agree && !loading ? _register : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB87A3D),
                              disabledBackgroundColor: Colors.grey,
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

                        // Login Link
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
                                  decoration: TextDecoration.underline,
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

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg),
            ),
          ],
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // 🔹 Glass TextField with Icon
  Widget _glassField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.white70)
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFB87A3D),
            width: 2,
          ),
        ),
      ),
    );
  }
}