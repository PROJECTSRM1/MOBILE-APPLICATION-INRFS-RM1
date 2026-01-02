import 'package:flutter/material.dart';
import '../../data/bonds_store.dart';

class BondsScreen extends StatelessWidget {
  const BondsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bonds = BondsStore.bonds;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Investment Bonds',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: bonds.isEmpty ? _emptyState() : _bondsList(bonds),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48),
            SizedBox(height: 16),
            Text(
              'No Bonds Issued Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Complete an investment plan to receive your certified digital bonds.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ================= BONDS LIST =================
  Widget _bondsList(List<BondItem> bonds) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bonds.length,
      itemBuilder: (context, index) {
        final bond = bonds[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(bond.planName),
            subtitle: Text(
              'Invested ₹${bond.investedAmount.toStringAsFixed(0)}\n'
              'Maturity ₹${bond.maturityValue.toStringAsFixed(0)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                Text('Active', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        );
      },
    );
  }
}
