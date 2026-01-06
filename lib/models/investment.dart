class Investment {
  final String investmentId;
  final String planName;
  final double investedAmount;
  final double returns;
  final double maturityValue;
  final String tenure;
  final String interest;
  final String status;
  final DateTime date;

  Investment({
    required this.investmentId,
    required this.planName,
    required this.investedAmount,
    required this.returns,
    required this.maturityValue,
    required this.tenure,
    required this.interest,
    required this.status,
    required this.date,
  });
}
