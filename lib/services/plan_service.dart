import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';

class PlanService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  static Future<List<PlanModel>> fetchPlans() async {
    final response =
        await http.get(Uri.parse('$baseUrl/plans/'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => PlanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }
}
