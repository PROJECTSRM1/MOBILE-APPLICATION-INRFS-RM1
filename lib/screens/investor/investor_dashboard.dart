import 'package:flutter/material.dart';

class InvestorDashboard extends StatelessWidget {
  const InvestorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestPro'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back, John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Customer ID: I1234'),

            const SizedBox(height: 20),

            /// SUMMARY CARDS
            Row(
              children: const [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Invested',
                    value: '\$45,000',
                    icon: Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Returns',
                    value: '\$6,750',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(
                  child: _SummaryCard(
                    title: 'Active Investments',
                    value: '5',
                    icon: Icons.pie_chart,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Digital Bonds',
                    value: '8',
                    icon: Icons.receipt_long,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(child: _ActionCard(icon: Icons.add, label: 'New Investment')),
                SizedBox(width: 12),
                Expanded(child: _ActionCard(icon: Icons.list, label: 'My Investments')),
                SizedBox(width: 12),
                Expanded(child: _ActionCard(icon: Icons.download, label: 'Download Bonds')),
                SizedBox(width: 12),
                Expanded(child: _ActionCard(icon: Icons.person, label: 'Profile')),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Investments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const _RecentInvestmentTable(),
          ],
        ),
      ),
    );
  }
}

/// ======================
/// SUMMARY CARD
/// ======================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// ======================
/// ACTION CARD
/// ======================
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// ======================
/// RECENT INVESTMENTS TABLE
/// ======================
class _RecentInvestmentTable extends StatelessWidget {
  const _RecentInvestmentTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: const [
          _InvestmentRow('INV-2024-001', '\$10,000', 'Active'),
          Divider(),
          _InvestmentRow('INV-2024-002', '\$5,000', 'Active'),
          Divider(),
          _InvestmentRow('INV-2023-045', '\$20,000', 'Completed'),
        ],
      ),
    );
  }
}

/// ======================
/// INVESTMENT ROW
/// ======================
class _InvestmentRow extends StatelessWidget {
  final String id;
  final String amount;
  final String status;

  const _InvestmentRow(this.id, this.amount, this.status);

  @override
  Widget build(BuildContext context) {
    final color = status == 'Active' ? Colors.green : Colors.blue;

    return Row(
      children: [
        Expanded(child: Text(id)),
        Expanded(child: Text(amount)),
        Chip(label: Text(status), backgroundColor: color.withValues(alpha: 0.15)),
      ],
    );
  }
}
