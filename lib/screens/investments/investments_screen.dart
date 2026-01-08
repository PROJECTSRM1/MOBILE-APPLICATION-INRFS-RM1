import 'package:flutter/material.dart';
import '../../data/investment_store.dart';
import '../../models/investment.dart';
import 'investment_details_screen.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {

  /// 🔄 Ensures screen refreshes when returning
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Single source of truth
    final List<Investment> investments =
        List.from(InvestmentStore.investments);

    return Scaffold(
      appBar: AppBar(title: const Text('My Investments')),
      body: investments.isEmpty
          ? const Center(
              child: Text(
                'No investments yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: investments.length,
              itemBuilder: (context, index) {
                final Investment i = investments[index];
                return _investmentCard(context, i);
              },
            ),
    );
  }

  // ---------------- Investment Card ----------------

  Widget _investmentCard(BuildContext context, Investment i) {
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
                i.investmentId,
                style: const TextStyle(
                  color: Color.fromARGB(255, 234, 170, 254),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              _row('Plan', i.planName),
              _row(
                'Amount',
                '₹${i.investedAmount.toStringAsFixed(0)}',
              ),
              _row(
                'Returns',
                '₹${i.returns.toStringAsFixed(0)}',
                valueColor: Colors.green,
              ),

              _statusRow(i),

              _row(
                'Maturity',
                '₹${i.maturityValue.toStringAsFixed(0)}',
              ),

              // Withdraw Button (Active only)
              if (i.status == 'Active') ...[
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _openDetails(context, i),
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

  Widget _statusRow(Investment i) {
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
              child: Chip(
                label: Text(
                  i.status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: i.status == 'Active'
                    ? const Color.fromARGB(255, 235, 177, 54)
                    : Colors.grey,
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

  void _openDetails(BuildContext context, Investment investment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            InvestmentDetailsScreen(investment: investment),
      ),
    );
  }
}
