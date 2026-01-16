import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/investment.dart';
import '../../services/investment_service.dart';
import '../../services/auth_service.dart';

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

  // ✅ Bank transfer proof file
  File? selectedProofFile;
  String? selectedFileName;

  void _calculate() {
    investmentAmount = double.tryParse(_amountController.text) ?? 0;
    expectedReturns = (investmentAmount * widget.interestRate) / 100;
    totalMaturity = investmentAmount + expectedReturns;
    setState(() {});
  }

  // ✅ Pick proof screenshot/pdf file
  Future<void> _pickProofFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg", "jpeg", "png", "pdf"],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedProofFile = File(result.files.single.path!);
        selectedFileName = result.files.single.name;
      });
    }
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

                // ✅ Payment info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ❌ Stripe (disabled)
                _paymentMethodButton(
                  icon: Icons.credit_card,
                  label: 'Pay with Stripe (Coming Soon)',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Stripe coming soon")),
                    );
                  },
                ),

                // ❌ PayPal (disabled)
                _paymentMethodButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Pay with PayPal (Coming Soon)',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("PayPal coming soon")),
                    );
                  },
                ),

                // ✅ Bank Transfer
                _paymentMethodButton(
                  icon: Icons.account_balance,
                  label: 'Bank Transfer',
                  onPressed: _submitBankTransferInvestment,
                ),

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

  // ✅ Bank Transfer Submit (Fixed fields + file upload)
  Future<void> _submitBankTransferInvestment() async {
    Navigator.pop(context); // close payment sheet

    if (investmentAmount <= 0) {
      _showError("Enter a valid investment amount");
      return;
    }

    if (selectedProofFile == null) {
      _showError("Please upload bank transfer proof before submitting.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
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

      // ✅ API CALL (multipart/form-data)
      await InvestmentService.createInvestmentBankTransfer(
        token: token,
        principalAmount: investmentAmount,
        planTypeId: widget.planId,
        maturityDate: maturityDate,
        uploadFile: selectedProofFile!,
      );

      if (!mounted) return;
      Navigator.pop(context); // close loader

      final investment = Investment(
        investmentId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        planName: widget.planName,
        investedAmount: investmentAmount,
        returns: expectedReturns,
        maturityValue: totalMaturity,
        tenure: '365 Days',
        interest: '${widget.interestRate}%',
        isActive: true,
        status: 'Pending Verification', // ✅ Bank transfer
        date: DateTime.now(),
      );

      _showSuccessDialog(investment);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loader
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Failed'),
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

  void _showSuccessDialog(Investment investment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Submitted Successfully ✅'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              '₹${investment.investedAmount.toStringAsFixed(0)} submitted successfully.\n\nStatus: Pending Verification',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
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
      appBar: AppBar(title: const Text('Complete Your Investment')),
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
            const SizedBox(height: 20),

            // ✅ Upload proof UI
            ElevatedButton.icon(
              onPressed: _pickProofFile,
              icon: const Icon(Icons.upload_file),
              label: Text(
                selectedFileName == null
                    ? "Upload Bank Transfer Proof"
                    : "Proof Selected ✅ ($selectedFileName)",
              ),
            ),

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
              title: const Text('I agree to the Terms & Conditions'),
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
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calculated Returns',
                style: TextStyle(color: Colors.white70)),
            Text(
              '₹${expectedReturns.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
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

  Widget _summary() => Column(
        children: [
          _summaryRow('Plan Type', widget.planName),
          _summaryRow(
              'Investment Amount', '₹${investmentAmount.toStringAsFixed(0)}'),
          _summaryRow('Interest Rate', '${widget.interestRate}%'),
          _summaryRow('Expected Returns',
              '₹${expectedReturns.toStringAsFixed(2)}',
              valueColor: Colors.green),
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
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: Icon(icon, color: const Color(0xFFB57B3A)),
          label: Text(label,
              style: const TextStyle(color: Color(0xFFB57B3A))),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
