import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../utils/investor_id_generator.dart';
import '../../services/otp_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  /// ✅ SAFE OTP VERIFICATION (NO WARNINGS)
  Future<void> _verifyOtp() async {
    final success = OTPService.verify(
      email: emailController.text,
      mobile: mobileController.text,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
      return;
    }

    final investorId = InvestorIdGenerator.generate();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registration Successful!\nYour Investor ID: $investorId',
        ),
      ),
    );

    // ⏳ Small delay so user can read the message
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // ✅ REQUIRED SAFETY CHECK

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email OTP'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(labelText: 'Mobile OTP'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
