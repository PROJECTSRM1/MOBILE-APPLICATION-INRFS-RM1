import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';
import '../dashboard/investor_dashboard.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool loading = false;
  String? errorMessage;

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text).join();

  /* ---------------- VERIFY OTP API ---------------- */

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) {
      setState(() => errorMessage = "Please enter 6-digit OTP");
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://inrfs-be.onrender.com/users/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": widget.email,
          "otp": _enteredOtp,
        }),
      );

      if (response.statusCode == 200) {
        // You can parse response if backend returns user data
        final user = UserModel(
          name: "Investor",
          mobile: "",
          email: widget.email,
          customerId: "INV001",
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InvestorDashboard(user: user),
          ),
        );
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          errorMessage = body['detail'] ?? 'Invalid OTP';
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Something went wrong");
    } finally {
      setState(() => loading = false);
    }
  }

  /* ---------------- OTP BOX ---------------- */

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP sent to',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              widget.email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _otpBox),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _verifyOtp,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
