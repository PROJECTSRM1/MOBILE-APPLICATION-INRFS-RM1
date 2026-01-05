class PlanModel {
  final int id;
  final String planType;
  final String percentage;
  final String duration;
  final bool isActive;
  final String description;

  PlanModel({
    required this.id,
    required this.planType,
    required this.percentage,
    required this.duration,
    required this.isActive,
    required this.description,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] ?? 0,
      planType: json['plan_type'] ?? '',
      percentage: json['percentage'] ?? '',
      duration: json['duration'] ?? '',
      isActive: json['is_active'] ?? false,
      description: json['description'] ?? '',
    );
  }
}
