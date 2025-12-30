import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../dashboard/investor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController identifierCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();

  bool loading = false;
  bool otpLoading = false;

  int resendSeconds = 30;
  Timer? _timer;

  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    otpCtrl.dispose();
    _timer?.cancel();
    _shakeCtrl.dispose();
    super.dispose();
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/share1.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.45)),
          Center(child: _loginCard()),
        ],
      ),
    );
  }

  Widget _loginCard() {
    return SingleChildScrollView(
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
              border: Border.all(color: Colors.white30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Investor Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _glassField(identifierCtrl, 'Email / Investor ID'),
                const SizedBox(height: 16),
                _glassField(passwordCtrl, 'Password', obscure: true),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
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

  /* ================= LOGIN ================= */

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
      _goToDashboard(res);
    } catch (e) {
      if (!mounted) return;

      if (e.toString().contains('OTP verification required')) {
        _showSnack('Please verify OTP to continue');
        _showOtpPopup();
      } else {
        _showSnack('Login failed. Please check your credentials.');
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  /* ================= OTP POPUP ================= */

  void _showOtpPopup() {
    otpCtrl.clear();
    resendSeconds = 30;
    _startTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: AnimatedBuilder(
          animation: _shakeCtrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(_shakeCtrl.value * 8, 0),
            child: child,
          ),
          child: _otpCard(),
        ),
      ),
    );
  }

  Widget _otpCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sms, color: Colors.white, size: 36),
              const SizedBox(height: 8),
              const Text(
                'Verify OTP',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),

              // PIN-style OTP
              TextField(
                controller: otpCtrl,
                maxLength: 6,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(
                  letterSpacing: 32,
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (v) {
                  if (v.length == 6 && !otpLoading) {
                    _verifyOtp();
                  }
                },
              ),

              const SizedBox(height: 12),

              Text(
                resendSeconds > 0
                    ? 'Resend in $resendSeconds s'
                    : 'Didn’t receive OTP?',
                style: const TextStyle(color: Colors.white70),
              ),

              TextButton(
                onPressed: resendSeconds == 0 ? _resendOtp : null,
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ================= OTP VERIFY ================= */

  Future<void> _verifyOtp() async {
    setState(() => otpLoading = true);

    try {
      final res = await AuthService.verifyOtp(
        email: identifierCtrl.text.trim(),
        otp: otpCtrl.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
      _goToDashboard(res);
    } catch (_) {
      _shakeCtrl.forward(from: 0);
      _showSnack('Invalid OTP');
    } finally {
      if (mounted) setState(() => otpLoading = false);
    }
  }

  /* ================= RESEND OTP ================= */

  Future<void> _resendOtp() async {
    resendSeconds = 30;
    _startTimer();
    await AuthService.resendOtp(email: identifierCtrl.text.trim());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;
        setState(() {
          if (resendSeconds > 0) resendSeconds--;
        });
      },
    );
  }

  /* ================= NAVIGATION ================= */

  void _goToDashboard(Map<String, dynamic> res) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => InvestorDashboard(
          user: UserModel(
            name: res['name'] ?? '',
            email: res['email'] ?? '',
            mobile: res['mobile'] ?? '',
            customerId: res['inv_reg_id'] ?? '',
          ),
        ),
      ),
    );
  }

  /* ================= HELPERS ================= */

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
