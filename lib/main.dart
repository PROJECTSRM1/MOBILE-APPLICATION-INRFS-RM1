import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';

// Screens
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/dashboard/investor_dashboard.dart';

// Models
import 'models/user_model.dart';

void main() {
  runApp(const INRFSApp());
}

class INRFSApp extends StatelessWidget {
  const INRFSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INRFS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,

      /// ✅ ONLY CORE ROUTES
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );

          case AppRoutes.login:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            );

          case AppRoutes.register:
            return MaterialPageRoute(
              builder: (_) => const RegisterScreen(),
            );

          case AppRoutes.otp:
            final args = settings.arguments;
            if (args is Map<String, dynamic> &&
                args['email'] is String) {
              return MaterialPageRoute(
                builder: (_) => OTPVerificationScreen(
                  email: args['email'],
                ),
              );
            }
            return _errorRoute('Invalid OTP arguments');

          case AppRoutes.dashboard:
            final args = settings.arguments;
            if (args is UserModel) {
              return MaterialPageRoute(
                builder: (_) => InvestorDashboard(user: args),
              );
            }
            return _errorRoute('Invalid user session');

          default:
            return _errorRoute('Route not found');
        }
      },

      /// ✅ BACKGROUND THEME
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF4E6),
                Color(0xFFFFE8CC),
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
