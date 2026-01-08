import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  // ✅ STORE TOKEN GLOBALLY
  static String? accessToken;

  /// LOGIN
  static Future<Map<String, dynamic>> loginUser({
    required String identifier,
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
      final data = jsonDecode(response.body);

      // 🔥 SAVE TOKEN HERE
      accessToken = data['access_token'];

      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }
}
