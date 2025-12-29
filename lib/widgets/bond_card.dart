import 'package:flutter/material.dart';
import '../models/bond_model.dart';
import '../screens/bonds/bond_details_screen.dart';

class BondCard extends StatelessWidget {
  final BondModel bond;

  const BondCard({super.key, required this.bond});

  @override
  Widget build(BuildContext context) {
    final isActive = bond.status == "Active";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bond.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text(bond.status),
                backgroundColor:
                    isActive ? Colors.green.shade100 : Colors.orange.shade100,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info("Investment", "₹${bond.amount.toInt()}"),
              _info("Interest", "${bond.interest}%"),
              _info("Tenure", "${bond.tenure} yrs"),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BondDetailsScreen(bond: bond),
                  ),
                );
              },
              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
