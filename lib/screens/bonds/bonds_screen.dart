import 'package:flutter/material.dart';
import '../../data/bonds_data.dart';
import '../../widgets/bond_card.dart';

class BondsScreen extends StatelessWidget {
  const BondsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Bonds"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: bondsList.length,
          itemBuilder: (context, index) {
            return BondCard(bond: bondsList[index]);
          },
        ),
      ),
    );
  }
}
