import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../services/investment_service.dart';
import '../../services/auth_service.dart';
import '../../utils/bond_pdf_generator.dart';
import '../../data/investment_store.dart';
import '../../models/bond.dart';

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

class _CompleteInvestmentScreenState extends State<CompleteInvestmentScreen> {
  final TextEditingController _amountController = TextEditingController();

  double investmentAmount = 0;
  double expectedReturns = 0;
  double totalMaturity = 0;
  bool agreed = false;

  /* ---------------- CALCULATION ---------------- */

  void _calculate() {
    investmentAmount = double.tryParse(_amountController.text) ?? 0;
    expectedReturns = (investmentAmount * widget.interestRate) / 100;
    totalMaturity = investmentAmount + expectedReturns;
    setState(() {});
  }

  /* ---------------- PAYMENT SHEET ---------------- */

  void _showPaymentSheet() {
    if (investmentAmount <= 0) {
      _showError('Enter a valid investment amount');
      return;
    }

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
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _paymentRow('Plan Type', widget.planName),
                      const SizedBox(height: 6),
                      _paymentRow(
                        'Amount to Pay',
                        '₹${investmentAmount.toStringAsFixed(0)}',
                        bold: true,
                      ),
                      const SizedBox(height: 6),
                      _paymentRow(
                        'Expected Returns',
                        '₹${expectedReturns.toStringAsFixed(0)}',
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                _paymentOptionButton(
                  icon: Icons.credit_card,
                  label: 'Pay with Stripe',
                  onTap: _confirmPayment,
                ),
                const SizedBox(height: 12),
                _paymentOptionButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Pay with PayPal',
                  onTap: _confirmPayment,
                ),
                const SizedBox(height: 12),
                _paymentOptionButton(
                  icon: Icons.account_balance,
                  label: 'Bank Transfer',
                  onTap: _confirmPayment,
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFB57B3A)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFB57B3A),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ---------------- CONFIRM PAYMENT ---------------- */

  Future<void> _confirmPayment() async {
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final token = AuthService.accessToken!;
      final maturityDate = DateTime.now()
          .add(const Duration(days: 365))
          .toIso8601String()
          .split('T')[0];

      final bondId = 'BOND-${DateTime.now().millisecondsSinceEpoch}';

      final bondFile = await BondPdfGenerator.generate(
        bondId: bondId,
        investorName: 'Investor',
        planName: widget.planName,
        amount: investmentAmount,
        interestRate: '${widget.interestRate}%',
        issueDate: DateTime.now(),
        maturityDate: DateTime.now().add(const Duration(days: 365)),
      );

      await InvestmentService.createInvestmentWithBond(
        token: token,
        principalAmount: investmentAmount,
        planTypeId: widget.planId,
        maturityDate: maturityDate,
        bondFile: bondFile,
      );

      InvestmentStore.bonds.add(
        Bond(
          bondId: bondId,
          planName: widget.planName,
          investedAmount: investmentAmount,
          maturityValue: totalMaturity,
          tenure: '365 Days',
          interest: '${widget.interestRate}%',
          status: 'Active',
          date: maturityDate,
          filePath: bondFile.path,
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);

      await OpenFilex.open(bondFile.path);

      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showError(e.toString());
    }
  }

  /* ---------------- ERROR ---------------- */

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1DE),
      appBar: AppBar(
        title: const Text('Complete Your Investment'),
        backgroundColor: const Color(0xFFFFF1DE),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _planChip(),
            const SizedBox(height: 24),

            const Text('Investment Amount'),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 20),
            _returnsCard(),
            const SizedBox(height: 30),
            _summarySection(),
            const SizedBox(height: 20),

            CheckboxListTile(
              value: agreed,
              onChanged: (v) => setState(() => agreed = v!),
              title: const Text('I agree to the Terms & Conditions'),
              controlAffinity: ListTileControlAffinity.trailing,
            ),

            const SizedBox(height: 20),
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

  /* ---------------- REUSABLE WIDGETS ---------------- */

  Widget _planChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Selected Plan: ${widget.planName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  /// ✅ FIXED PAYMENT ROW (NEAT SMALL SIZE + BOLD + NO OVERFLOW)
  Widget _paymentRow(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: bold ? 15 : 14, // ✅ reduced neatly
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _paymentOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: const Color(0xFFB57B3A)),
        label: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB57B3A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFB57B3A)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _returnsCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigo],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculated Returns',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              '₹${expectedReturns.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Total Maturity: ₹${totalMaturity.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );

  Widget _summarySection() => Column(
        children: [
          _summaryRow('Plan Type', widget.planName),
          _summaryRow(
            'Investment Amount',
            '₹${investmentAmount.toStringAsFixed(0)}',
          ),
          _summaryRow('Interest Rate', '${widget.interestRate}%'),
          _summaryRow(
            'Expected Returns',
            '₹${expectedReturns.toStringAsFixed(2)}',
            valueColor: Colors.green,
          ),
          const Divider(),
          _summaryRow(
            'Total Maturity Amount',
            '₹${totalMaturity.toStringAsFixed(2)}',
            bold: true,
            valueColor: Colors.blue,
          ),
        ],
      );

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
              fontWeight: bold ? FontWeight.bold : null,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}