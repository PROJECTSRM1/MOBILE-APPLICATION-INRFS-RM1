class BondModel {
  final String bondId;
  final String planName;
  final double investedAmount;
  final double maturityValue;
  final String tenure;
  final String interest;
  final String status;
  final String date;

  BondModel({
    required this.bondId,
    required this.planName,
    required this.investedAmount,
    required this.maturityValue,
    required this.tenure,
    required this.interest,
    required this.status,
    required this.date,
  });
}
