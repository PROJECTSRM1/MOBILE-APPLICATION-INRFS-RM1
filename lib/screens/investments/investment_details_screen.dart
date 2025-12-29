import 'package:flutter/material.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final dynamic investment;

  const InvestmentDetailsScreen({
    super.key,
    required this.investment,
  });

  @override
  State<InvestmentDetailsScreen> createState() =>
      _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState
    extends State<InvestmentDetailsScreen> {
  bool showProsCons = false;
  String selectedTab = ''; // 'pros' or 'cons'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: const Text('Investment Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF4E6),
              Color(0xFFFFE8CC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= OVERVIEW =================
                _sectionTitle('Overview'),
                _whiteCard(
                  child: Column(
                    children: [
                      _infoRow('Investment ID', widget.investment.id),
                      _infoRow('Plan', widget.investment.plan),
                      _infoRow(
                          'Amount', '₹${widget.investment.amount}'),
                      _infoRow(
                          'Returns', '₹${widget.investment.returns}'),
                      _infoRow(
                          'Maturity', widget.investment.maturity),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ================= RISK =================
                _sectionTitle('Risk Meter'),
                _whiteCard(child: _riskMeter()),

                const SizedBox(height: 24),

                // ================= PROS & CONS =================
                TextButton(
                  onPressed: () {
                    setState(() {
                      showProsCons = !showProsCons;
                      selectedTab = '';
                    });
                  },
                  child: const Text(
                    'Pros & Cons',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB87A3D),
                    ),
                  ),
                ),

                if (showProsCons) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTab = 'pros';
                            });
                          },
                          style: _tabButtonStyle(selectedTab == 'pros'),
                          child: const Text('Pros'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTab = 'cons';
                            });
                          },
                          style: _tabButtonStyle(selectedTab == 'cons'),
                          child: const Text('Cons'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (selectedTab == 'pros')
                    _whiteCard(
                      child: Column(
                        children: const [
                          _Bullet(
                              text:
                                  'Stable and predictable returns'),
                          _Bullet(text: 'Low volatility'),
                          _Bullet(
                              text:
                                  'Professional fund management'),
                        ],
                      ),
                    ),

                  if (selectedTab == 'cons')
                    _whiteCard(
                      child: Column(
                        children: const [
                          _Bullet(
                              text:
                                  'Limited liquidity during lock-in'),
                          _Bullet(
                              text:
                                  'Early withdrawal penalty'),
                          _Bullet(
                              text:
                                  'Returns subject to market risks'),
                        ],
                      ),
                    ),
                ],

                const SizedBox(height: 28),

                // ================= ACTIONS =================
                if (widget.investment.isActive) ...[
                  _sectionTitle('Actions'),
                  _whiteCard(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                            },
                            child:
                                const Text('Withdraw Investment'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                            },
                            child: const Text('Change Plan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  ButtonStyle _tabButtonStyle(bool selected) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: selected
          ? const Color(0xFFB87A3D)
          : Colors.transparent,
      foregroundColor:
          selected ? Colors.white : const Color(0xFFB87A3D),
      side: const BorderSide(color: Color(0xFFB87A3D)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskMeter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medium Risk',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.6,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          color: Colors.orange,
        ),
      ],
    );
  }
}

// ================= BULLET =================

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Color(0xFFB87A3D),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
