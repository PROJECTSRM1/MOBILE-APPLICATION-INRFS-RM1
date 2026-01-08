import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/investment.dart';
import '../../services/investment_service.dart';
import '../../services/auth_service.dart';

import '../investments/investments_screen.dart';



class CompleteInvestmentScreen extends StatefulWidget {
  final int planId;
  final String planName;
  final double interestRate;

  const CompleteInvestmentScreen({
    super.key,
    required this.planId,
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const Text(
          '1. Investment is locked for the selected tenure period.\n'
          '2. Returns are calculated based on the fixed interest rate.\n'
          '3. Digital bond will be issued after payment confirmation.\n'
          '4. Early withdrawal may incur penalties.\n'
          '5. Maturity amount will be credited to your account.',
          style: TextStyle(fontSize: 12),
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

  void _showPaymentSheet() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _paymentInfoRow(
                          'Plan Type', widget.planName),
                      _paymentInfoRow(
                        'Amount to Pay',
                        '₹${investmentAmount.toStringAsFixed(0)}',
                        bold: true,
                      ),
                      _paymentInfoRow(
                        'Expected Returns',
                        '₹${expectedReturns.toStringAsFixed(0)}',
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _paymentMethodButton(
                    icon: Icons.credit_card,
                    label: 'Pay with Stripe'),
                _paymentMethodButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Pay with PayPal'),
                _paymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'Bank Transfer'),
                const SizedBox(height: 14),
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
  }

  /// 🔥 REAL BACKEND SAVE HAPPENS HERE
void _processPayment() async {
  Navigator.pop(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        const Center(child: CircularProgressIndicator()),
  );

  try {
    final token = AuthService.accessToken;

    if (token == null) {
      throw Exception('User not authenticated. Please login again.');
    }

    final maturityDate = DateTime.now()
        .add(const Duration(days: 365))
        .toIso8601String()
        .split('T')[0];

    await InvestmentService.postInvestment(
      token: token, // ✅ REAL TOKEN
      amount: investmentAmount,
      planId: widget.planId,
      maturityDate: maturityDate,
    );

    if (!mounted) return;
    Navigator.pop(context);

    // final investment = Investment(
    //   investmentId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
    //   planName: widget.planName,
    //   investedAmount: investmentAmount,
    //   returns: expectedReturns,
    //   maturityValue: totalMaturity,
    //   tenure: '3 Months',
    //   interest: '${widget.interestRate}% p.a.',
    //   status: 'Active',
    //   date: DateTime.now(),
    // );


     
  final investment = Investment(
      investmentId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      planName: widget.planName,
      investedAmount: investmentAmount,
      returns: expectedReturns,
      maturityValue: totalMaturity,
      tenure: 'As per plan',
      interest: '${widget.interestRate}%',
      status: 'Active',
      date: DateTime.now(),
    );

    _showSuccessDialog(investment);
  } catch (e) {
    if (!mounted) return;
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

  void _showSuccessDialog(Investment investment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 60, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              '₹${investment.investedAmount.toStringAsFixed(0)} invested successfully.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(
                  context, (route) => route.isFirst);
            },
            child: const Text('View Investments'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Complete Your Investment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _planInfo(),
            const SizedBox(height: 24),
            const Text('Investment Amount'),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 20),
            _returnsCard(),
            const SizedBox(height: 32),
            _summary(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _showTermsDialog,
              child: const Text('Terms & Conditions'),
            ),
            CheckboxListTile(
              value: agreed,
              onChanged: (v) => setState(() => agreed = v!),
              title:
                  const Text('I agree to the Terms & Conditions'),
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
                    onPressed:
                        agreed ? _showPaymentSheet : null,
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

  Widget _planInfo() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Selected Plan: ${widget.planName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  Widget _returnsCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.blue, Colors.indigo]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calculated Returns',
                style: TextStyle(color: Colors.white70)),
            Text('₹${expectedReturns.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(
              'Total Maturity: ₹${totalMaturity.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );

  Widget _summary() => Column(
        children: [
          _summaryRow('Plan Type', widget.planName),
          _summaryRow('Investment Amount',
              '₹${investmentAmount.toStringAsFixed(0)}'),
          _summaryRow(
              'Interest Rate', '${widget.interestRate}%'),
          _summaryRow('Expected Returns',
              '₹${expectedReturns.toStringAsFixed(2)}',
              valueColor: Colors.green),
          const Divider(),
          _summaryRow(
              'Total Maturity Amount',
              '₹${totalMaturity.toStringAsFixed(2)}',
              bold: true,
              valueColor: Colors.blue),
        ],
      );

  Widget _summaryRow(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : null,
                  color: valueColor)),
        ],
      ),
    );
  }

 Widget _paymentInfoRow(
  String label,
  String value, {
  bool bold = false,
  Color? valueColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13, // ✅ FIX
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13, // ✅ FIX
            fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    ),
  );
}

  Widget _paymentMethodButton(
      {required IconData icon,
      required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: Icon(icon,
              color: const Color(0xFFB57B3A)),
          label: Text(label,
              style: const TextStyle(
                  color: Color(0xFFB57B3A))),
          onPressed: _processPayment,
        ),
      ),
    );
  }
}
