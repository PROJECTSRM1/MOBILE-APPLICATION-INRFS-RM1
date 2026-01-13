// lib/screens/auth/forgot_password_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/share1.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
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
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.2),
                                  child: const Icon(
                                    Icons.lock_reset,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Enter your registered email address',
                                  style: TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle:
                                        const TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withValues(alpha: 0.15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
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
                                    onPressed: loading ? null : _submitRequest,
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
                                            'Send Reset Link',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      _showSnack('Please enter your email');
      return;
    }

    // Validate email format first
    if (!_isValidEmail(email)) {
      _showCompactDialog(
        title: 'Invalid Email',
        message: 'Please enter a valid email address.',
        icon: Icons.error_outline,
        iconColor: Colors.orange,
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService.requestPasswordReset(email);

      if (!mounted) return;

      setState(() => loading = false);

      // Show success dialog and navigate to reset screen
      _showCompactDialog(
        title: 'Success',
        message: 'Password reset link sent to your email.',
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        onOkPressed: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ResetPasswordScreen(),
            ),
          );
        },
      );
    } catch (e) {
      print('❌ Forgot password error: $e');
      if (mounted) {
        setState(() => loading = false);

        final errorMessage = e.toString().toLowerCase();
        
        // Check if email is not registered (404 or specific error message)
        if (errorMessage.contains('not found') ||
            errorMessage.contains('not registered') ||
            errorMessage.contains('does not exist') ||
            errorMessage.contains('404')) {
          _showCompactDialog(
            title: 'Email Not Found',
            message: 'Entered email is not registered.',
            icon: Icons.info_outline,
            iconColor: Colors.blue,
          );
        } else {
          _showCompactDialog(
            title: 'Error',
            message: e.toString().replaceAll('Exception: ', ''),
            icon: Icons.error_outline,
            iconColor: Colors.red,
          );
        }
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showCompactDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onOkPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 48),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB87A3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (onOkPressed != null) {
                        onOkPressed();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}