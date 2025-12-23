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
    );
  }
}
