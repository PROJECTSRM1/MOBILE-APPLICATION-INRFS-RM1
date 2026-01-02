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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Investment Plan'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PlanModel>>(
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

          final plans = snapshot.data!;
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
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
/// PLAN CARD (VERTICAL)
//////////////////////////////////////////////////////////////////////////////

class _PlanCard extends StatelessWidget {
  final PlanModel plan;
  const _PlanCard({required this.plan});

  Color get _backgroundColor {
    if (plan.durationMonths <= 1) {
      return const Color(0xFFFFF6E5);
    } else if (plan.durationMonths <= 3) {
      return const Color(0xFFFFF0D6);
    } else if (plan.durationMonths <= 6) {
      return const Color(0xFFEAF7EE);
    } else {
      return const Color(0xFFFFECEC);
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
            plan.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// ROI
          Text(
            '${plan.returnsPercentage}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          Text(
            'Returns in ${plan.durationMonths} months',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            plan.description,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 20),

          /// BUTTON
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompleteInvestmentScreen(
                      planName: plan.name,
                      interestRate: plan.returnsPercentage,
                    ),
                  ),
                );
              },
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
