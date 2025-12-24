import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';

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
          return _investmentCard(i);
        },
      ),
    );
  }

  Widget _investmentCard(dynamic i) {
    return Card(
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
            _row(
              'Status',
              i.isActive ? 'Active' : 'Completed',
              chip: true,
              chipColor: i.isActive ? Colors.green : Colors.blue,
            ),
            _row('Maturity', i.maturity),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool chip = false,
    Color? chipColor,
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
            child: chip
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      label: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: chipColor,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                : Text(
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
}
