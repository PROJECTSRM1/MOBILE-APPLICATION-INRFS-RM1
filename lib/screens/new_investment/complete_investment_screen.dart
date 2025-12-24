import 'package:flutter/material.dart';

class CompleteInvestmentScreen extends StatefulWidget {
  final String planName;
  final double interestRate;

  const CompleteInvestmentScreen({
    super.key,
    required this.planName,
    required this.interestRate,
  });

  @override
  State<CompleteInvestmentScreen> createState() =>
      _CompleteInvestmentScreenState();
}

class _CompleteInvestmentScreenState
    extends State<CompleteInvestmentScreen> {
  final TextEditingController _amountController =
      TextEditingController();

  double investmentAmount = 0;
  double expectedReturns = 0;
  double totalMaturity = 0;
  bool agreed = false;

  void _calculate() {
    investmentAmount =
        double.tryParse(_amountController.text) ?? 0;

    expectedReturns =
        (investmentAmount * widget.interestRate) / 100;

    totalMaturity = investmentAmount + expectedReturns;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Investment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // SELECTED PLAN INFO
            // =========================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(
                    color: Colors.blue.shade700,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Plan: ${widget.planName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your investment amount to see calculated returns',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // INVESTMENT AMOUNT
            // =========================
            const Text(
              'Investment Amount',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 6),
            const Text(
              'Minimum: \$1,000 | Maximum: \$1,000,000',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // CALCULATED RETURNS (SEPARATE ROW)
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calculated Returns',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${expectedReturns.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total Maturity: \$${totalMaturity.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // =========================
            // INVESTMENT SUMMARY
            // =========================
            const Text(
              'Investment Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _summaryRow('Plan Type', widget.planName),
            _summaryRow(
              'Investment Amount',
              '\$${investmentAmount.toStringAsFixed(0)}',
            ),
            _summaryRow(
              'Interest Rate',
              '${widget.interestRate}%',
            ),
            _summaryRow(
              'Expected Returns',
              '\$${expectedReturns.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),

            const Divider(height: 32),

            _summaryRow(
              'Total Maturity Amount:',
              '\$${totalMaturity.toStringAsFixed(2)}',
              bold: true,
              valueColor: Colors.blue,
            ),

            const SizedBox(height: 24),

            // =========================
            // TERMS & CONDITIONS
            // =========================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Investment is locked for the selected tenure period.\n'
                    '2. Returns are calculated based on the fixed interest rate.\n'
                    '3. Digital bond will be issued immediately after payment confirmation.\n'
                    '4. Early withdrawal may incur penalties as per policy.\n'
                    '5. All investments are subject to regulatory compliance.\n'
                    '6. Interest is calculated on a simple interest basis.\n'
                    '7. Maturity amount will be credited to your registered account.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v!),
                    title: const Text(
                      'I have read and agree to the Terms & Conditions',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // ACTION BUTTONS
            // =========================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Plans'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: agreed ? () {} : null,
                    child: const Text('Proceed to Payment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
