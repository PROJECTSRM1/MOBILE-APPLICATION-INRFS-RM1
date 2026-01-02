import 'dart:ui';
import 'package:flutter/material.dart';
import '../bonds/bonds_screen.dart';
import '../../models/bond_model.dart';
import '../bonds/bonds_data.dart';


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

  // =========================
  // CALCULATE RETURNS
  // =========================
  void _calculate() {
    investmentAmount =
        double.tryParse(_amountController.text) ?? 0;

    expectedReturns =
        (investmentAmount * widget.interestRate) / 100;

    totalMaturity = investmentAmount + expectedReturns;

    setState(() {});
  }

  // =========================
  // TERMS POPUP
  // =========================
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Investment is locked for the selected tenure period.\n'
            '2. Returns are calculated based on the fixed interest rate.\n'
            '3. Digital bond will be issued immediately after payment confirmation.\n'
            '4. Early withdrawal may incur penalties as per policy.\n'
            '5. All investments are subject to regulatory compliance.\n'
            '6. Interest is calculated on a simple interest basis.\n'
            '7. Maturity amount will be credited to your registered account.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // =========================
  // PAYMENT MODAL (GLASS UI)
  // =========================
  void _showPaymentSheet() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _paymentRow('Plan Type', widget.planName),
                    _paymentRow(
                      'Amount to Pay',
                      '₹${investmentAmount.toStringAsFixed(0)}',
                      bold: true,
                    ),
                    _paymentRow(
                      'Expected Returns',
                      '₹${expectedReturns.toStringAsFixed(0)}',
                      valueColor: Colors.green,
                    ),

                    const SizedBox(height: 24),

                    _paymentButton(
                      icon: Icons.credit_card,
                      text: 'Pay with Stripe',
                    ),
                    _paymentButton(
                      icon: Icons.account_balance_wallet,
                      text: 'Pay with PayPal',
                    ),
                    _paymentButton(
                      icon: Icons.account_balance,
                      text: 'Bank Transfer',
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // PROCESS PAYMENT (FAKE)
  // =========================
 void _processPayment() {
  Navigator.pop(context); // close payment modal

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;

    Navigator.pop(context); // close loader

    // ✅ ADD BOND TO LIST
    bondsList.insert(
      0,
      BondModel(
        bondId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        planName: widget.planName,
        investedAmount: investmentAmount,
        maturityValue: totalMaturity,
        tenure: '${(widget.interestRate == 18 ? 6 : 3)} Months',
        interest: '${widget.interestRate}% p.a.',
        status: 'Active',
        date: DateTime.now().toString().split(' ').first,
      ),
    );

    // ✅ NAVIGATE TO BONDS
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const BondsScreen()),
      (route) => false,
    );
  });
}

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Investment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PLAN INFO
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
                    style:
                        const TextStyle(fontWeight: FontWeight.bold),
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

            const Text(
              'Investment Amount',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 20),

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
                    '₹${expectedReturns.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total Maturity: ₹${totalMaturity.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Investment Summary',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _summaryRow('Plan Type', widget.planName),
            _summaryRow(
              'Investment Amount',
              '₹${investmentAmount.toStringAsFixed(0)}',
            ),
            _summaryRow(
              'Interest Rate',
              '${widget.interestRate}%',
            ),
            _summaryRow(
              'Expected Returns',
              '₹${expectedReturns.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),

            const Divider(height: 32),

            _summaryRow(
              'Total Maturity Amount',
              '₹${totalMaturity.toStringAsFixed(2)}',
              bold: true,
              valueColor: Colors.blue,
            ),

            const SizedBox(height: 24),

            TextButton(
              onPressed: () => _showTermsDialog(context),
              child: const Text(
                'Terms & Conditions',
                style:
                    TextStyle(decoration: TextDecoration.underline),
              ),
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: agreed,
              onChanged: (v) => setState(() => agreed = v!),
              title: const Text(
                'I agree to the Terms & Conditions',
                style: TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 24),

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
                    onPressed: agreed ? _showPaymentSheet : null,
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

  // =========================
  // HELPERS
  // =========================
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

  Widget _paymentRow(
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
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentButton({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: Icon(icon),
          label: Text(text),
          onPressed: _processPayment,
        ),
      ),
    );
  }
}
