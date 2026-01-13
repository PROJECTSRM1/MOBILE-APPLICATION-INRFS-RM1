// class Investment {
//   final String investmentId;
//   final String planName;
//   final double investedAmount;
//   final double returns;
//   final double maturityValue;
//   final String tenure;
//   final String interest;

//   /// ✅ KEEP BOTH
//   final bool isActive;
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
//     required this.isActive,
//     required this.status,
//     required this.date,
//   });

//   // ===========================
//   // BACKEND → MODEL MAPPER
//   // ===========================
//   factory Investment.fromApi(Map<String, dynamic> json) {
//     final bool active = json['is_active'] == true;

//     return Investment(
//       investmentId: json['uk_inv_id'],
//       planName: 'Plan ${json['plan_type_id']}',
//       investedAmount:
//           (json['principal_amount'] as num).toDouble(),
//       returns:
//           (json['interest_amount'] as num).toDouble(),
//       maturityValue:
//           (json['maturity_amount'] as num).toDouble(),
//       tenure: _tenureFromDates(
//         json['created_date'],
//         json['maturity_date'],
//       ),
//       interest: '${json['interest_amount']}',
//       isActive: active,
//       status: active ? 'Active' : 'Completed',
//       date: DateTime.parse(json['created_date']),
//     );
//   }

//   static String _tenureFromDates(
//     String start,
//     String end,
//   ) {
//     final s = DateTime.parse(start);
//     final e = DateTime.parse(end);
//     final months =
//         ((e.year - s.year) * 12) + (e.month - s.month);
//     return '$months Months';
//   }
// }









class Investment {
  final String investmentId;
  final String planName;
  final double investedAmount;
  final double returns;
  final double maturityValue;
  final String tenure;
  final String interest;
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
      investmentId: json['uk_inv_id']?.toString() ?? 'N/A',
      planName: json['plan_name'] ?? 'Plan ${json['plan_type_id'] ?? 'Unknown'}',
      investedAmount: _parseDouble(json['principal_amount']),
      returns: _parseDouble(json['interest_amount']),
      maturityValue: _parseDouble(json['maturity_amount']),
      tenure: _tenureFromDates(
        json['created_date'],
        json['maturity_date'],
      ),
      interest: '${json['interest_rate'] ?? json['interest_amount'] ?? '0'}%',
      isActive: active,
      status: active ? 'Active' : 'Completed',
      date: _parseDate(json['created_date']),
    );
  }

  // ===========================
  // HELPER: Calculate Tenure
  // ===========================
  static String _tenureFromDates(dynamic start, dynamic end) {
    try {
      if (start == null || end == null) return 'N/A';
      
      final s = DateTime.parse(start.toString());
      final e = DateTime.parse(end.toString());
      
      final months = ((e.year - s.year) * 12) + (e.month - s.month);
      
      if (months == 0) {
        final days = e.difference(s).inDays;
        return '$days Days';
      }
      
      return '$months Months';
    } catch (e) {
      return 'N/A';
    }
  }

  // ===========================
  // HELPER: Safe Double Parser
  // ===========================
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // ===========================
  // HELPER: Safe Date Parser
  // ===========================
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // ===========================
  // TO JSON (Optional)
  // ===========================
  Map<String, dynamic> toJson() {
    return {
      'uk_inv_id': investmentId,
      'plan_name': planName,
      'principal_amount': investedAmount,
      'interest_amount': returns,
      'maturity_amount': maturityValue,
      'tenure': tenure,
      'interest': interest,
      'is_active': isActive,
      'status': status,
      'created_date': date.toIso8601String(),
    };
  }

  // ===========================
  // COPY WITH (Optional)
  // ===========================
  Investment copyWith({
    String? investmentId,
    String? planName,
    double? investedAmount,
    double? returns,
    double? maturityValue,
    String? tenure,
    String? interest,
    bool? isActive,
    String? status,
    DateTime? date,
  }) {
    return Investment(
      investmentId: investmentId ?? this.investmentId,
      planName: planName ?? this.planName,
      investedAmount: investedAmount ?? this.investedAmount,
      returns: returns ?? this.returns,
      maturityValue: maturityValue ?? this.maturityValue,
      tenure: tenure ?? this.tenure,
      interest: interest ?? this.interest,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}




