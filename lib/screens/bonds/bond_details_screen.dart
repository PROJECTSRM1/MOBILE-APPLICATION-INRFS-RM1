import 'package:flutter/material.dart';
import '../../models/bond_model.dart';

class BondDetailsScreen extends StatelessWidget {
  final BondModel bond;

  const BondDetailsScreen({super.key, required this.bond});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bond.planName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Bond ID', bond.bondId),
            _row('Plan Name', bond.planName),
            _row('Invested Amount', '₹${bond.investedAmount.toStringAsFixed(0)}'),
            _row('Maturity Value', '₹${bond.maturityValue.toStringAsFixed(0)}'),
            _row('Tenure', bond.tenure),
            _row('Interest', bond.interest),
            _row('Status', bond.status),
            _row('Date', bond.date),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
