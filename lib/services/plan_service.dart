import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';

class PlanService {
  static const String baseUrl =
      'https://inrfs-be.onrender.com/plans/';

  static Future<List<PlanModel>> fetchPlans() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list
          .map((e) => PlanModel.fromJson(e))
          .where((p) => p.isActive)
          .toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }
}
