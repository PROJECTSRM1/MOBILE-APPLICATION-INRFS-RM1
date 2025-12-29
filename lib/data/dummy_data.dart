import '../models/user_model.dart';

/* =======================
   Dummy User
======================= */
final dummyUser = UserModel(
  name: 'John Doe',
  mobile: '9876543210',
  email: 'john@example.com',
  customerId: 'I1234',
);

/* =======================
   Investment Model
======================= */
class Investment {
  final String id;
  final String plan;        // ✅ added
  final String maturity;    // ✅ added
  final int amount;
  final int returns;
  final bool isActive;

  Investment({
    required this.id,
    required this.plan,
    required this.maturity,
    required this.amount,
    required this.returns,
    required this.isActive,
  });
}

/* =======================
   Dummy Investments
======================= */
final List<Investment> investments = [
  Investment(
    id: 'INV-2024-001',
    plan: 'Gold Plan',
    maturity: '12 Months',
    amount: 10000,
    returns: 1800,
    isActive: true,
  ),
  Investment(
    id: 'INV-2024-002',
    plan: 'Silver Plan',
    maturity: '6 Months',
    amount: 5000,
    returns: 600,
    isActive: true,
  ),
  Investment(
    id: 'INV-2023-045',
    plan: 'Platinum Plan',
    maturity: '24 Months',
    amount: 20000,
    returns: 4800,
    isActive: false,
  ),
];
