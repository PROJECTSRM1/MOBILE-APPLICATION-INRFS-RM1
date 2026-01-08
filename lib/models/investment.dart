// class Investment {
//   final String investmentId;
//   final String planName;
//   final double investedAmount;
//   final double returns;
//   final double maturityValue;
//   final String tenure;
//   final String interest;
//   final String status;
//   final DateTime date;

//   Investment({
//     required this.investmentId,
//     required this.planName,
//     required this.investedAmount,
//     required this.returns,
//     required this.maturityValue,
//     required this.tenure,
//     required this.interest,
//     required this.status,
//     required this.date,
//   });
// }








class Investment {
  final String investmentId;
  final String planName;
  final double investedAmount;
  final double returns;
  final double maturityValue;
  final String tenure;
  final String interest;

  /// ✅ KEEP BOTH
  final bool isActive;
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
    required this.isActive,
    required this.status,
    required this.date,
  });

  // ===========================
  // BACKEND → MODEL MAPPER
  // ===========================
  factory Investment.fromApi(Map<String, dynamic> json) {
    final bool active = json['is_active'] == true;

    return Investment(
      investmentId: json['uk_inv_id'],
      planName: 'Plan ${json['plan_type_id']}',
      investedAmount:
          (json['principal_amount'] as num).toDouble(),
      returns:
          (json['interest_amount'] as num).toDouble(),
      maturityValue:
          (json['maturity_amount'] as num).toDouble(),
      tenure: _tenureFromDates(
        json['created_date'],
        json['maturity_date'],
      ),
      interest: '${json['interest_amount']}',
      isActive: active,
      status: active ? 'Active' : 'Completed',
      date: DateTime.parse(json['created_date']),
    );
  }

  static String _tenureFromDates(
    String start,
    String end,
  ) {
    final s = DateTime.parse(start);
    final e = DateTime.parse(end);
    final months =
        ((e.year - s.year) * 12) + (e.month - s.month);
    return '$months Months';
  }
}
