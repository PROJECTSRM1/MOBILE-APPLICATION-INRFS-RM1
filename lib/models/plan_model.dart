class PlanModel {
  final int id;
  final String name;
  final double returnsPercentage;
  final int durationMonths;
  final String description;
  final bool isActive;

  PlanModel({
    required this.id,
    required this.name,
    required this.returnsPercentage,
    required this.durationMonths,
    required this.description,
    required this.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      name: json['name'],
      returnsPercentage:
          (json['returns_percentage'] as num).toDouble(),
      durationMonths: json['duration_months'],
      description: json['description'],
      isActive: json['is_active'],
    );
  }
}
