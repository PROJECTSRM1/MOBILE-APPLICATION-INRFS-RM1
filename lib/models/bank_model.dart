class BankModel {
  final String? id;
  final int bankId;
  final String bankAccountNo;
  final String ifscCode;
  final bool? isVerified;
  final String? bankName;
  final DateTime? createdAt;

  BankModel({
    this.id,
    required this.bankId,
    required this.bankAccountNo,
    required this.ifscCode,
    this.isVerified,
    this.bankName,
    this.createdAt,
  });

  String get maskedAccountNo {
    if (bankAccountNo.length <= 4) return bankAccountNo;
    return '****${bankAccountNo.substring(bankAccountNo.length - 4)}';
  }

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id']?.toString(),
      bankId: json['bank_id'] ?? 0,
      bankAccountNo: json['bank_account_no'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      isVerified: json['is_verified'],
      bankName: json['bank_name'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'bank_account_no': bankAccountNo,
      'ifsc_code': ifscCode,
    };
  }
}