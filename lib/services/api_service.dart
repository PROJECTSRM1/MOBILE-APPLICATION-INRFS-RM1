import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  // ===========================
  // COMMON HEADERS
  // ===========================
  static Map<String, String> _headers({String? token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  // ===========================
  // REGISTER USER (EXISTING)
  // ===========================
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/register');

    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "password": password,
        "gender_id": 1,
        "age": 25,
        "dob": "1999-01-01"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Registration failed: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // ===========================
  // CREATE INVESTMENT (POST)
  // ===========================
  static Future<Map<String, dynamic>> createInvestment({
    required String planName,
    required double amount,
    required double interestRate,
    required double returns,
    required double maturityValue,
    required String tenure,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/');

    final response = await http.post(
      url,
      headers: _headers(token: token),
      body: jsonEncode({
        "plan_name": planName,
        "invested_amount": amount,
        "interest_rate": interestRate,
        "returns": returns,
        "maturity_value": maturityValue,
        "tenure": tenure,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Investment creation failed: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // ===========================
  // GET MY INVESTMENTS (NEW)
  // ===========================
  static Future<List<dynamic>> getMyInvestments({
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/my');

    final response = await http.get(
      url,
      headers: _headers(token: token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Failed to fetch investments: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
