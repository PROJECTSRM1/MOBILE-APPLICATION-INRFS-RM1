class SupportTicketModel {
  final String? id;
  final String userId;
  final String category;
  final String subject;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SupportTicketModel({
    this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      category: json['category'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category': category,
      'subject': subject,
      'description': description,
      'status': status,
    };
  }
}