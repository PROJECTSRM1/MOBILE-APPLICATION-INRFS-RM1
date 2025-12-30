import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/user_model.dart';

class DashboardHome extends StatefulWidget {
  final UserModel user;

  const DashboardHome({
    super.key,
    required this.user,
  });

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  /// -----------------------------
  /// MOCK SENSEX DATA (REALTIME-LIKE)
  /// -----------------------------
  final List<FlSpot> _sensexPoints = [];
  Timer? _timer;
  double _currentSensex = 72000;

  /// -----------------------------
  /// DUMMY INVESTMENT DATA
  /// -----------------------------
  final List<Map<String, dynamic>> investments = [
    {
      'plan': 'Growth Plan',
      'amount': 10000,
      'returns': 1800,
      'active': true,
    },
    {
      'plan': 'Income Plan',
      'amount': 5000,
      'returns': 600,
      'active': true,
    },
    {
      'plan': 'Secure Bond',
      'amount': 20000,
      'returns': 4800,
      'active': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSensexSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// -----------------------------
  /// FAKE REALTIME SENSEX
  /// -----------------------------
  void _startSensexSimulation() {
    for (int i = 0; i < 10; i++) {
      _sensexPoints.add(FlSpot(i.toDouble(), _currentSensex));
    }

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        _currentSensex += Random().nextDouble() * 40 - 20;
        _sensexPoints.add(
          FlSpot(_sensexPoints.length.toDouble(), _currentSensex),
        );

        if (_sensexPoints.length > 20) {
          _sensexPoints.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalInvested =
        investments.fold<int>(0, (sum, i) => sum + i['amount'] as int);

    final totalReturns =
        investments.fold<int>(0, (sum, i) => sum + i['returns'] as int);

    final activeCount =
        investments.where((i) => i['active'] == true).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -----------------------------
          /// HEADER
          /// -----------------------------
          Text(
            'Welcome Back, ${widget.user.name}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('Customer ID: ${widget.user.customerId}'),

          const SizedBox(height: 20),

          /// -----------------------------
          /// SENSEX GRAPH
          /// -----------------------------
          _sensexCard(),

          const SizedBox(height: 20),

          /// -----------------------------
          /// SUMMARY CARDS
          /// -----------------------------
          Row(
            children: [
              _summaryCard(
                'Total Invested',
                '₹$totalInvested',
                Icons.account_balance_wallet,
                const Color(0xFFC5A572),
              ),
              const SizedBox(width: 12),
              _summaryCard(
                'Total Returns',
                '₹$totalReturns',
                Icons.trending_up,
                const Color(0xFFC5A572),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _summaryCard(
                'Active Investments',
                '$activeCount',
                Icons.pie_chart,
                const Color(0xFFC5A572),
              ),
              const SizedBox(width: 12),
              _summaryCard(
                'Digital Bonds',
                '8',
                Icons.receipt_long,
                const Color(0xFFC5A572),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// -----------------------------
          /// INVESTMENT LIST
          /// -----------------------------
          const Text(
            'Your Investments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...investments.map(_investmentCard),
        ],
      ),
    );
  }

  /// -----------------------------
  /// SENSEX CARD
  /// -----------------------------
  Widget _sensexCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SENSEX (Live)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _currentSensex.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _sensexPoints,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 3,
                    color: const Color(0xFF10B981),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -----------------------------
  /// INVESTMENT CARD
  /// -----------------------------
  Widget _investmentCard(Map<String, dynamic> investment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                investment['plan'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('Invested: ₹${investment['amount']}'),
              Text('Returns: ₹${investment['returns']}'),
            ],
          ),
          Chip(
            label: Text(
              investment['active'] ? 'ACTIVE' : 'CLOSED',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor:
                investment['active'] ? const Color.fromARGB(255, 85, 29, 15) : const Color(0xFFC5A572),
          ),
        ],
      ),
    );
  }

  /// -----------------------------
  /// SUMMARY CARD
  /// -----------------------------
  Expanded _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Color(0xFFC5A572))),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    );
  }
}
