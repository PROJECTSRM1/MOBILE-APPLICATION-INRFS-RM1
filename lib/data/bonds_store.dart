class BondItem {
  final String bondId;
  final String planName;
  final double investedAmount;
  final double maturityValue;
  final String tenure;
  final double interest;
  final String inrfcNo;
  final String date;

  BondItem({
    required this.bondId,
    required this.planName,
    required this.investedAmount,
    required this.maturityValue,
    required this.tenure,
    required this.interest,
    required this.inrfcNo,
    required this.date,
  });
}

class BondsStore {
  static final List<BondItem> bonds = [];
}
