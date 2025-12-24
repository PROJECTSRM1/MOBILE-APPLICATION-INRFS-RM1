import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../new_investment/plans_screen.dart';


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
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
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
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Investments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'New Invest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Bonds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // =========================
  // BODY SWITCHER
  // =========================
  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return _simplePage('My Investments');
      case 2:
  return const PlansScreen();

      case 3:
        return _simplePage('Bonds');
      case 4:
        return _profilePage();
      default:
        return _dashboardHome();
    }
  }

  // =========================
  // DASHBOARD HOME
  // =========================
  Widget _dashboardHome() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.user.name}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text('Customer ID: ${widget.user.customerId}'),
          const SizedBox(height: 24),

          const Text(
            'Dashboard Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _summaryTile('Total Investment', '₹45,000'),
          _summaryTile('Total Returns', '₹6,750'),
          _summaryTile('Active Investments', '5'),
          _summaryTile('Digital Bonds', '8'),
        ],
      ),
    );
  }

  // =========================
  // PROFILE PAGE
  // =========================
  Widget _profilePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(widget.user.name),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Mobile'),
            subtitle: Text(widget.user.mobile),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(widget.user.email),
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('Customer ID'),
            subtitle: Text(widget.user.customerId),
          ),
        ],
      ),
    );
  }

  // =========================
  // SIMPLE PLACEHOLDER PAGES
  // =========================
  Widget _simplePage(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // =========================
  // SUMMARY TILE
  // =========================
  Widget _summaryTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
