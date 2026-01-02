import 'package:flutter/material.dart';
import '../../data/bonds_store.dart';

class BondsScreen extends StatelessWidget {
  const BondsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Investment Bonds'),
      ),
      body: bondsList.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bondsList.length,
              itemBuilder: (context, index) {
                final bond = bondsList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      bond.planName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invested: ₹${bond.investedAmount.toStringAsFixed(0)}',
                        ),
                        Text(
                          'Maturity: ₹${bond.maturityValue.toStringAsFixed(0)}',
                        ),
                        Text('Tenure: ${bond.tenure}'),
                        Text('Interest: ${bond.interest}'),
                        Text('Date: ${bond.date}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(bond.status),
                      backgroundColor: Colors.green.shade100,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.inventory_2_outlined, size: 48),
          SizedBox(height: 12),
          Text(
            'No Bonds Issued Yet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Complete an investment plan to receive your certified digital bonds.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
