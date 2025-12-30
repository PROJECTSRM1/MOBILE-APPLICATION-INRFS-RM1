import 'package:flutter/material.dart';
import 'dart:ui';
import '../bonds/bonds_screen.dart';


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
  // PAYMENT SUCCESS HANDLER
  // =========================
 void _handlePaymentSuccess() {
  Navigator.pop(context); // close payment popup

  BondsStore.addBond(
    BondModel(
      bondId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      planName: widget.planName,
      investedAmount: investmentAmount,
      maturityValue: totalMaturity,
      tenure: '${widget.interestRate}% p.a.',
      interest: '${widget.interestRate}%',
      status: 'Active',
      date: 'Dec 30, 2025',
    ),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const BondsScreen()),
  );
}

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
        content: SingleChildScrollView(
          child: const Text(
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
void _showProcessingPopup() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Processing Payment...',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    },
  );
}
void _showPaymentSuccessPopup() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 12),

              const Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your investment has been successfully processed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close success popup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BondsScreen(),
                      ),
                    );
                  },
                  child: const Text('View Bond'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
void _startPaymentProcess() {
  Navigator.pop(context); // close payment options popup

  _showProcessingPopup();

  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;

    Navigator.pop(context); // close processing popup
    _showPaymentSuccessPopup();
  });
}

  // =========================
  // PAYMENT MODAL
  // =========================
 void _showPaymentSheet() {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
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
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _paymentInfoRow('Plan Type', widget.planName),
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

                  const SizedBox(height: 24),

                 _paymentButton(
  icon: Icons.credit_card,
  text: 'Pay with Stripe',
  onTap:_startPaymentProcess,
),

                 _paymentButton(
  icon: Icons.account_balance_wallet,
  text: 'Pay with PayPal',
  onTap: _startPaymentProcess,
),

                 _paymentButton(
  icon: Icons.account_balance,
  text: 'Bank Transfer',
  onTap: _handlePaymentSuccess,
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

            // AMOUNT INPUT
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

            // CALCULATED RETURNS
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

            // SUMMARY
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

            // TERMS
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

            // ACTIONS
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

  Widget _paymentInfoRow(
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
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor:
                highlight ? Colors.blue.shade50 : Colors.white,
            side: BorderSide(
              color: highlight ? Colors.blue : Colors.grey.shade300,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: onTap,
          icon: Icon(icon, size: 20),
          label: Text(text),
        ),
      ),
    );
  }
}
