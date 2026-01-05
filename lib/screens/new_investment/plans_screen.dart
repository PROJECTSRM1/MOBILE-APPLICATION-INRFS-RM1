import 'package:flutter/material.dart';
import '../../models/plan_model.dart';
import '../../services/plan_service.dart';
import 'complete_investment_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late Future<List<PlanModel>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = PlanService.fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlanModel>>(
      future: _plansFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final plans = snapshot.data ?? [];

        if (plans.isEmpty) {
          return const Center(child: Text('No plans available'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            return _PlanCard(plan: plans[index]);
          },
        );
      },
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
/// PLAN CARD (UPDATED – WITH DESCRIPTION)
//////////////////////////////////////////////////////////////////////////////

class _PlanCard extends StatelessWidget {
  final PlanModel plan;
  const _PlanCard({required this.plan});

  /// Convert "15 %" → 15.0
  double _parsePercentage(String value) {
    return double.tryParse(value.replaceAll('%', '').trim()) ?? 0.0;
  }

  Color get _backgroundColor {
    if (plan.duration.contains('3')) {
      return const Color(0xFFFFF0D6);
    } else if (plan.duration.contains('6')) {
      return const Color(0xFFEAF7EE);
    } else if (plan.duration.contains('12')) {
      return const Color(0xFFFFECEC);
    } else {
      return const Color(0xFFFFF6E5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PLAN NAME
          Text(
            plan.planType,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// ROI
          Text(
            plan.percentage,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          /// DURATION
          Text(
            'Duration: ${plan.duration}',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          /// DESCRIPTION (NEW)
          Text(
            plan.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          /// STATUS
          Chip(
            label: Text(
              plan.isActive ? 'Active' : 'Inactive',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: plan.isActive
                ? const Color.fromARGB(255, 169, 144, 70)
                : Colors.grey,
          ),

          const SizedBox(height: 20),

          /// SELECT BUTTON
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87A3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: plan.isActive
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompleteInvestmentScreen(
                            planName: plan.planType,
                            interestRate:
                                _parsePercentage(plan.percentage),
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                'Select Plan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
