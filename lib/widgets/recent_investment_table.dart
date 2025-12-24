import 'package:flutter/material.dart';

class RecentInvestmentTable extends StatelessWidget {
  const RecentInvestmentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: const [
          _InvestmentRow('INV-2024-001', '₹10,000', 'Active'),
          Divider(),
          _InvestmentRow('INV-2024-002', '₹5,000', 'Active'),
          Divider(),
          _InvestmentRow('INV-2023-045', '₹20,000', 'Completed'),
        ],
      ),
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  final String id;
  final String amount;
  final String status;

  const _InvestmentRow(
    this.id,
    this.amount,
    this.status,
  );

  @override
  Widget build(BuildContext context) {
    final color = status == 'Active' ? Colors.green : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(id)),
          Expanded(child: Text(amount)),
          Chip(
            label: Text(status),
            backgroundColor: color.withValues(alpha: 0.15),
            labelStyle: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
