import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Background Image
          Image.asset(
            'assets/images/coins.jpg',
            fit: BoxFit.cover,
          ),

          // 🔹 Overlay content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset(
  'assets/images/inrfs_logo.gif',
  width: 250,
  gaplessPlayback: true, // prevents flicker
),

              const SizedBox(height: 16),
              const Text(
                'INRFS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
