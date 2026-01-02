import 'package:flutter/material.dart';
import '../models/bond_model.dart';

class BondCard extends StatelessWidget {
  final BondModel bond;

  const BondCard({super.key, required this.bond});

  @override
  Widget build(BuildContext context) {
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
            Text('Invested: ₹${bond.investedAmount.toStringAsFixed(0)}'),
            Text('Maturity: ₹${bond.maturityValue.toStringAsFixed(0)}'),
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
  }
}
