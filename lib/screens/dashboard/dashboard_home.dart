import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../data/investment_store.dart';
import '../../models/investment.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class DashboardHome extends StatefulWidget {
  final UserModel user;

  const DashboardHome({
    super.key,
    required this.user,
  });

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  bool _isLoading = true;
  String _userName = '';
  String _customerId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ✅ Convert "Plan 1" / "Plan 2" → "Short-Term Starter" / "Quaterly Builder"
  String _getPlanName(String planName) {
    final name = planName.trim();

    // ✅ If already a proper name, return it
    if (!name.toLowerCase().contains("plan")) return name;

    // ✅ Extract number from "Plan 1", "Plan 2"
    final numPart = name.replaceAll(RegExp(r'[^0-9]'), '');
    final planId = int.tryParse(numPart) ?? 0;

    // ✅ Map Plan ID → Plan Title
    switch (planId) {
      case 1:
        return "Short-Term Starter";
      case 2:
        return "Quaterly Builder";
      case 3:
        return "Half-Year Growth";
      case 4:
        return "Yearly Wealth Plan";
      default:
        return "Unknown Plan";
    }
  }

  // ✅ Sort investments latest first using Investment ID (INV0197 > INV0196)
  List<Investment> _getSortedInvestments(List<Investment> list) {
    final sorted = List<Investment>.from(list);

    sorted.sort((a, b) {
      final aNum =
          int.tryParse(a.investmentId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final bNum =
          int.tryParse(b.investmentId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return bNum.compareTo(aNum); // ✅ descending
    });

    return sorted;
  }

  Future<void> _loadData() async {
    final token = AuthService.accessToken;

    // Use the user data we already have from widget.user
    _userName = widget.user.displayFirstName;
    _customerId = widget.user.invRegId ?? widget.user.customerId ?? '';

    if (token == null || token.isEmpty) {
      debugPrint('❌ No auth token found');
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      // Fetch investments
      final investmentsData = await ApiService.getMyInvestments(token: token);

      InvestmentStore.investments
        ..clear()
        ..addAll(investmentsData.map((e) => Investment.fromApi(e)));

      debugPrint('✅ Found ${investmentsData.length} investments');

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('❌ Load data error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B6E4E),
          ),
        ),
      );
    }

    // ✅ Investments list sorted latest first
    final List<Investment> investments =
        _getSortedInvestments(InvestmentStore.investments);

    final double totalInvested = investments.fold(
      0,
      (sum, i) => sum + i.investedAmount,
    );

    final double totalReturns = investments.fold(
      0,
      (sum, i) => sum + i.returns,
    );

    final int activeCount =
        investments.where((i) => i.status == 'Active').length;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF8B6E4E),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userName.isNotEmpty ? 'Welcome Back, $_userName' : 'Welcome Back',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _customerId.isNotEmpty
                    ? 'Customer ID: $_customerId'
                    : 'Customer ID: ${widget.user.invRegId ?? widget.user.customerId ?? ""}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _summaryCard(
                    'Total Invested',
                    '₹${totalInvested.toStringAsFixed(0)}',
                    Icons.account_balance_wallet,
                  ),
                  const SizedBox(width: 12),
                  _summaryCard(
                    'Total Returns',
                    '₹${totalReturns.toStringAsFixed(0)}',
                    Icons.trending_up,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _summaryCard(
                    'Active Investments',
                    '$activeCount',
                    Icons.pie_chart,
                  ),
                  const SizedBox(width: 12),
                  _summaryCard(
                    'Digital Bonds',
                    '${InvestmentStore.bonds.length}',
                    Icons.receipt_long,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Recent Investments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              investments.isEmpty
                  ? _emptyState()
                  : Column(
                      children: investments
                          .take(3)
                          .map((inv) => _investmentCard(inv))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Investment Card with Plan Name Mapping
  Widget _investmentCard(Investment investment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPlanName(investment.planName), // ✅ show correct name
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Invested: ₹${investment.investedAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Returns: ₹${investment.returns.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              investment.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            backgroundColor: investment.status == 'Active'
                ? const Color(0xFFB87A3D)
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _boxDecoration(),
      child: const Center(
        child: Text(
          'No investments yet.\nStart a new investment to see it here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFC5A572)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFC5A572),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    );
  }
}
