import 'package:flutter/material.dart';
import '../../data/investment_store.dart';
import '../../models/investment.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'investment_details_screen.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() =>
      _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  Future<void> _loadInvestments() async {
    final token = AuthService.accessToken;

    // 🔒 SAFETY CHECK
    if (token == null || token.isEmpty) {
      debugPrint('❌ No auth token found');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login again'),
          ),
        );
      }
      setState(() => loading = false);
      return;
    }

    try {
      final data =
          await ApiService.getMyInvestments(token: token);

      InvestmentStore.investments
        ..clear()
        ..addAll(
          data.map((e) => Investment.fromApi(e)),
        );

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Load investments error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load investments'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final investments = InvestmentStore.investments;

    return Scaffold(
      appBar: AppBar(
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : investments.isEmpty
              ? const Center(child: Text('No investments found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: investments.length,
                  itemBuilder: (context, index) {
                    final i = investments[index];
                    return _investmentCard(context, i);
                  },
                ),
    );
  }

  // ================= Investment Card =================

  Widget _investmentCard(BuildContext context, Investment i) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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

            const SizedBox(height: 10),

            _row('Plan', i.planName),
            _row(
              'Amount',
              '₹${i.investedAmount.toStringAsFixed(0)}',
            ),
            _row(
              'Returns',
              '₹${i.returns.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),

            // ================= STATUS ROW =================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: i.isActive
                            ? const Color.fromARGB(
                                255, 235, 177, 54)
                            : const Color.fromARGB(
                                255, 228, 168, 240),
                        visualDensity:
                            VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _row('Maturity', i.tenure),

            // ================= WITHDRAW BUTTON =================
            if (i.isActive) ...[
              const SizedBox(height: 14),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () =>
                        _safeOpenDetails(context, i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(
                              255, 184, 122, 61),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Withdraw',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= ROW UI =================

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

  // ================= SAFE NAVIGATION =================

  void _safeOpenDetails(
    BuildContext context,
    Investment investment,
  ) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              InvestmentDetailsScreen(investment: investment),
        ),
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Unable to open investment details'),
        ),
      );
    }
  }
}
