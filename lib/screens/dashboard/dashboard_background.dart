import 'package:flutter/material.dart';

class DashboardBackground extends StatelessWidget {
  final Widget child;

  const DashboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
  }
}
