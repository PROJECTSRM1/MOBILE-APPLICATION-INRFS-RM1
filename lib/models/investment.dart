class Investment {
  final String id;
  final String plan;
  final String maturity;
  final double amount;
  final double returns;
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
