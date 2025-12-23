import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Background image
          Image.asset(
            'assets/images/share1.jpg',
            fit: BoxFit.cover,
          ),

          // 🔹 Dark overlay
          Container(color: Colors.black.withValues(alpha: 0.4)),


          // 🔹 Registration Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Title
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🔹 First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: _inputStyle('First Name'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: _inputStyle('Last Name'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Email
                    TextField(
                      decoration: _inputStyle(
                        'Email Address',
                        hint: 'john.doe@example.com',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Mobile
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: _inputStyle(
                        'Mobile Number',
                        hint: '+91 98765 43210',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Password
                    TextField(
                      obscureText: true,
                      decoration: _inputStyle('Password'),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Confirm Password
                    TextField(
                      obscureText: true,
                      decoration: _inputStyle('Confirm Password'),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (v) {
                            setState(() => agree = v ?? false);
                          },
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'I agree to the Terms & Conditions and Privacy Policy',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Register button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: agree
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.otp,
                                );
                              }
                            : null,
                        child: const Text(
                          'Register & Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login here',
                            style: TextStyle(
                              color: Colors.blue,
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
        ],
      ),
    );
  }

  static InputDecoration _inputStyle(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
