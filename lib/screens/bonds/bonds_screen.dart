import 'package:flutter/material.dart';

import '../../data/bonds_store.dart';
import '../../widgets/bond_card.dart';

class BondsScreen extends StatelessWidget {
  const BondsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bonds = BondsStore.bonds;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Investment Bonds"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: bonds.isEmpty
            ? _emptyState()
            : ListView.builder(
                itemCount: bonds.length,
                itemBuilder: (context, index) {
                  return BondCard(bond: bonds[index]);
                },
              ),
      ),
    );
  }

  // =========================
  // EMPTY STATE UI
  // =========================
  Widget _emptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),

              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No Bonds Issued Yet',
              style: TextStyle(
                fontSize: 18,
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
}
