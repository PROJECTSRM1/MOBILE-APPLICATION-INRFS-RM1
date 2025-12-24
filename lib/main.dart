import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';

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
      routes: AppRoutes.routes,

      // ✅ GLOBAL BACKGROUND THEME (ADDED)
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF4E6), // light cream
                Color(0xFFFFE8CC), // soft beige
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}
