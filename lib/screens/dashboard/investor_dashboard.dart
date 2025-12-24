import 'package:flutter/material.dart';
import 'package:inrfs/profile/profile_screen.dart';
import 'package:inrfs/screens/bonds/bonds_screen.dart';
import 'package:inrfs/screens/investments/investments_screen.dart';
import 'package:inrfs/screens/new_investment/plans_screen.dart';
import '../../models/user_model.dart';
import 'dashboard_home.dart';

class InvestorDashboard extends StatefulWidget {
  final UserModel user;

  const InvestorDashboard({
    super.key,
    required this.user,
  });

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.trending_up),
            SizedBox(width: 8),
            Text('INRFS'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.red),
            onPressed: () {
              Navigator.pop(context); // logout
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Investments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'New Invest'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Bonds'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return const InvestmentsScreen();
      case 2:
        return const PlansScreen();
      case 3:
        return const BondsScreen();
      case 4:
        return ProfileScreen(user: widget.user);
      default:
        return DashboardHome(user: widget.user);
    }
  }
}
