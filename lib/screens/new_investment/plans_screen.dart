import 'package:flutter/material.dart';
import 'complete_investment_screen.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose Your Investment Plan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select the plan that best fits your financial goals',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 600;
                final double cardWidth =
                    isMobile ? constraints.maxWidth : 260;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    PlanCard(
                      width: cardWidth,
                      title: '1 Month Plan',
                      percent: '8%',
                      duration: 'Returns in 30 days',
                      interestRate: 8,
                      points: const [
                        'Quick returns',
                        'Low risk investment',
                        'Flexible amount',
                        'Digital bond issued',
                      ],
                    ),
                    PlanCard(
                      width: cardWidth,
                      title: '3 Month Plan',
                      percent: '12%',
                      duration: 'Returns in 90 days',
                      interestRate: 12,
                      points: const [
                        'Better returns',
                        'Balanced risk',
                        'Popular choice',
                        'Digital bond issued',
                      ],
                    ),
                    PlanCard(
                      width: cardWidth,
                      title: '6 Month Plan',
                      percent: '18%',
                      duration: 'Returns in 180 days',
                      interestRate: 18,
                      highlight: true,
                      badge: 'MOST POPULAR',
                      points: const [
                        'High returns',
                        'Best value',
                        'Recommended plan',
                        'Digital bond issued',
                      ],
                    ),
                    PlanCard(
                      width: cardWidth,
                      title: 'Yearly Plan',
                      percent: '24%',
                      duration: 'Returns in 365 days',
                      interestRate: 24,
                      points: const [
                        'Maximum returns',
                        'Long term growth',
                        'Wealth building',
                        'Digital bond issued',
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
/// 🔹 PLAN CARD (SINGLE SOURCE OF TRUTH)
//////////////////////////////////////////////////////////////////////////////
class PlanCard extends StatefulWidget {
  final double width;
  final String title;
  final String percent;
  final String duration;
  final double interestRate;
  final List<String> points;
  final bool highlight;
  final String? badge;

  const PlanCard({
    super.key,
    required this.width,
    required this.title,
    required this.percent,
    required this.duration,
    required this.interestRate,
    required this.points,
    this.highlight = false,
    this.badge,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        padding: const EdgeInsets.all(16),
        transform: _isHovered
            ? Matrix4.translationValues(0, -6, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered || widget.highlight
                ? Colors.blue
                : Colors.grey.shade300,
            width: _isHovered || widget.highlight ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              widget.percent,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              widget.duration,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            ...widget.points.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompleteInvestmentScreen(
                        planName: widget.title
                            .replaceAll(' Plan', '')
                            .toLowerCase(),
                        interestRate: widget.interestRate,
                      ),
                    ),
                  );
                },
                child: const Text('Select Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
