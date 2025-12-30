import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  /// -------------------------------
  /// LOGIN
  /// -------------------------------
  /// Login using either EMAIL or INVESTOR REGISTRATION ID
  static Future<Map<String, dynamic>> loginUser({
    required String identifier, // email OR inv_reg_id
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/login');

    final Map<String, dynamic> body = {
      "password": password,
    };

    if (identifier.contains('@')) {
      body["email"] = identifier;
    } else {
      body["inv_reg_id"] = identifier;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }

  /// -------------------------------
  /// VERIFY OTP
  /// -------------------------------
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/verify-otp');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'OTP verification failed');
    }
  }

  /// -------------------------------
  /// RESEND OTP
  /// -------------------------------
  static Future<void> resendOtp({
    required String email,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/resend-otp');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to resend OTP');
    }
  }
}
