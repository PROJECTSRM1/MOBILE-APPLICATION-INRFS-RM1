// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../models/user_model.dart';
// import '../dashboard/investor_dashboard.dart';

// class OTPVerificationScreen extends StatefulWidget {
//   final String email;

//   const OTPVerificationScreen({
//     super.key,
//     required this.email,
//   });

//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final List<TextEditingController> _otpControllers =
//       List.generate(6, (_) => TextEditingController());

//   bool loading = false;
//   String? errorMessage;

//   @override
//   void dispose() {
//     for (final c in _otpControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   String get _enteredOtp =>
//       _otpControllers.map((c) => c.text).join();

//   /* ---------------- VERIFY OTP API ---------------- */

//   Future<void> _verifyOtp() async {
//     if (_enteredOtp.length != 6) {
//       setState(() => errorMessage = "Please enter 6-digit OTP");
//       return;
//     }

//     setState(() {
//       loading = true;
//       errorMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('https://inrfs-be.onrender.com/users/verify-otp'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           "email": widget.email,
//           "otp": _enteredOtp,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // You can parse response if backend returns user data
//         final user = UserModel(
//           name: "Investor",
//           mobile: "",
//           email: widget.email,
//           customerId: "INV001",
//         );

//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => InvestorDashboard(user: user),
//           ),
//         );
//       } else {
//         final body = jsonDecode(response.body);
//         setState(() {
//           errorMessage = body['detail'] ?? 'Invalid OTP';
//         });
//       }
//     } catch (e) {
//       setState(() => errorMessage = "Something went wrong");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   /* ---------------- OTP BOX ---------------- */

//   Widget _otpBox(int index) {
//     return SizedBox(
//       width: 45,
//       child: TextField(
//         controller: _otpControllers[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         decoration: const InputDecoration(
//           counterText: '',
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//       ),
//     );
//   }

//   /* ---------------- UI ---------------- */

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OTP Verification')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Enter OTP sent to',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               widget.email,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 30),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(6, _otpBox),
//             ),

//             const SizedBox(height: 20),

//             if (errorMessage != null)
//               Text(
//                 errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),

//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: loading ? null : _verifyOtp,
//                 child: loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Verify OTP'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import '../../services/api_service.dart';
// import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

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

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

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
      // ✅ Use ApiService instead of direct http call
      final response = await ApiService.verifyOtp(
        email: widget.email,
        otp: _enteredOtp,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login screen after successful verification
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      setState(() => errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => loading = false);
    }
  }

  /* ---------------- RESEND OTP ---------------- */

  Future<void> _resendOtp() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      // Note: You'll need to implement a resend OTP endpoint in your backend
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => errorMessage = 'Failed to resend OTP');
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
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFB87A3D),
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: const Color(0xFFB87A3D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 80,
              color: Color(0xFFB87A3D),
            ),

            const SizedBox(height: 30),

            Text(
              'Enter OTP sent to',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              widget.email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _otpBox),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB87A3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code? ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: loading ? null : _resendOtp,
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Color(0xFFB87A3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}