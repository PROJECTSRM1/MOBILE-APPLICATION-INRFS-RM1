import 'dart:convert';
import 'package:http/http.dart' as http;

class InvestmentService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  static Future<void> postInvestment({
    required String token,
    required double amount,
    required int planId,
    required String maturityDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/investments/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // 🔥 IMPORTANT
      },
      body: jsonEncode({
        'principal_amount': amount,
        'plan_type_id': planId,
        'maturity_date': maturityDate,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(
        error['detail'] ?? 'Failed to save investment',
      );
    }
  }
}
