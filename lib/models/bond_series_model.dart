class BondSeriesModel {
  final int series;
  final double interest;
  final int tenure;
  final String payout;
  final bool highest;

  const BondSeriesModel({
    required this.series,
    required this.interest,
    required this.tenure,
    required this.payout,
    this.highest = false,
  });
}
