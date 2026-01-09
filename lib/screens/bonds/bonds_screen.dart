import 'package:flutter/material.dart';
import '../../data/investment_store.dart';

class BondsScreen extends StatelessWidget {
  const BondsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bonds = InvestmentStore.bonds; // ✅ single source of truth

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context); // ⬅ back to dashboard
        //   },
        // ),
      ),
      body: bonds.isEmpty ? _emptyState() : _bondList(bonds),
    );
  }

  // =========================
  // BOND LIST
  // =========================
  Widget _bondList(List bonds) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bonds.length,
      itemBuilder: (context, index) {
        final bond = bonds[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PLAN + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bond.planName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        bond.status,
                        style: const TextStyle(color: Colors.green),
                      ),
                      backgroundColor: Colors.green.shade100,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                _row('Bond ID', bond.bondId),
                _row(
                  'Invested Amount',
                  '₹${bond.investedAmount.toStringAsFixed(0)}',
                ),
                _row(
                  'Maturity Value',
                  '₹${bond.maturityValue.toStringAsFixed(0)}',
                ),
                _row('Tenure', bond.tenure),
                _row('Interest', bond.interest),
                _row('Date', bond.date),

                const SizedBox(height: 8),

                // DOWNLOAD BUTTON (optional)
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                   onPressed: null, // disabled until implemented

                    icon: const Icon(Icons.download),
                    label: const Text('Download Bond'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // EMPTY STATE
  // =========================
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt_long, size: 56, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Bonds Issued Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Complete an investment plan to receive your certified digital bonds.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HELPER ROW
  // =========================
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
