import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import 'investment_details_screen.dart';

class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Investments')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: investments.length,
        itemBuilder: (context, index) {
          final i = investments[index];
          return _investmentCard(context, i);
        },
      ),
    );
  }

  // ---------------- Investment Card ----------------

  Widget _investmentCard(BuildContext context, dynamic i) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openDetails(context, i),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Investment ID
              Text(
                i.id,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              _row('Plan', i.plan),
              _row('Amount', '₹${i.amount}'),
              _row(
                'Returns',
                '₹${i.returns}',
                valueColor: Colors.green,
              ),

              // Status Chip (Clickable)
              _statusRow(context, i),

              _row('Maturity', i.maturity),

              // Withdraw Button (Active only)
              if (i.isActive) ...[
                const SizedBox(height: 12),
               Center(
  child: SizedBox(
    width: 140, // 👈 control button width here
    height: 40,
    child: ElevatedButton(
      onPressed: () => _openDetails(context, i),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text('Withdraw'),
    ),
  ),
),

    
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Status Row ----------------

  Widget _statusRow(BuildContext context, dynamic i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Status',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => _openDetails(context, i),
                child: Chip(
                  label: Text(
                    i.isActive ? 'Active' : 'Completed',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      i.isActive ? Colors.green : Colors.blue,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Row UI ----------------

  Widget _row(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Navigation ----------------

  void _openDetails(BuildContext context, dynamic investment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            InvestmentDetailsScreen(investment: investment),
      ),
    );
  }
}
