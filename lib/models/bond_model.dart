class BondModel {
  final String name;
  final double amount;
  final double interest;
  final int tenure;
  final String status;
  final String rating;
  final String issuer;
  final String ipoDate;
  final List<String> pros;
  final List<String> cons;
  final String about;


  BondModel({
    required this.name,
    required this.amount,
    required this.interest,
    required this.tenure,
    required this.status,
    required this.rating,
    required this.issuer,
    required this.ipoDate,
    required this.pros,
    required this.cons,
    required this.about,
  });
}
