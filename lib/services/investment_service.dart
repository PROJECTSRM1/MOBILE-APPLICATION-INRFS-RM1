// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class InvestmentService {
//   static const String baseUrl = 'https://inrfs-be.onrender.com';

//   static Future<void> postInvestment({
//     required String token,
//     required double amount,
//     required int planId,
//     required String maturityDate,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/investments/'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // 🔥 IMPORTANT
//       },
//       body: jsonEncode({
//         'principal_amount': amount,
//         'plan_type_id': planId,
//         'maturity_date': maturityDate,
//       }),
//     );

//     if (response.statusCode != 200 &&
//         response.statusCode != 201) {
//       final error = jsonDecode(response.body);
//       throw Exception(
//         error['detail'] ?? 'Failed to save investment',
//       );
//     }
//   }
// }









import 'dart:convert';
import 'package:http/http.dart' as http;

class InvestmentService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  static Map<String, String> _headers({required String token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// POST INVESTMENT
  static Future<Map<String, dynamic>> postInvestment({
    required String token,
    required double amount,
    required int planId,
    required String maturityDate,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/');

    final response = await http.post(
      url,
      headers: _headers(token: token),
      body: jsonEncode({
        "plan_id": planId,
        "invested_amount": amount,
        "maturity_date": maturityDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create investment');
    }
  }

  /// GET MY INVESTMENTS
  static Future<List<dynamic>> getMyInvestments({
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/my');

    final response = await http.get(
      url,
      headers: _headers(token: token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else if (data is Map && data.containsKey('investments')) {
        return data['investments'] as List<dynamic>;
      }
      return [];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to fetch investments');
    }
  }

  /// WITHDRAW INVESTMENT
  static Future<Map<String, dynamic>> withdrawInvestment({
    required String token,
    required String investmentId,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/$investmentId/withdraw');

    final response = await http.post(
      url,
      headers: _headers(token: token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to withdraw investment');
    }
  }
}