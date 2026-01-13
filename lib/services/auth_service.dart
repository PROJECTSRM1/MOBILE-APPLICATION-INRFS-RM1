// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  static String? accessToken;

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

    print('🔐 Logging in with: ${body.keys.first}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('📥 Login Response Status: ${response.statusCode}');
    print('📥 Login Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      accessToken = data['access_token'];

      print('✅ Login Success');
      print('📌 Token saved: ${accessToken?.substring(0, 20)}...');
      print('📌 Customer ID: ${data['Customer-ID']}');
      print('📌 First Name: ${data['First_Name']}');

      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }

  /// Request password reset - sends reset link to registered email only
  static Future<void> requestPasswordReset(String email) async {
    final Uri url = Uri.parse('$baseUrl/users/forgot-password');

    print('📧 Requesting password reset for: $email');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      print('📥 Forgot Password Response Status: ${response.statusCode}');
      print('📥 Forgot Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Password reset email sent successfully');
        return;
      } else if (response.statusCode == 404) {
        // Email not found/not registered
        throw Exception('Email not registered');
      } else if (response.statusCode == 422) {
        // Invalid email format
        throw Exception('Invalid email format');
      } else if (response.statusCode == 400) {
        // Bad request - email not registered
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Email not registered');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to send reset email');
      }
    } catch (e) {
      print('❌ Request password reset error: $e');
      rethrow;
    }
  }

  /// Reset password using token from email
  static Future<void> resetPassword(String token, String newPassword) async {
    final Uri url = Uri.parse('$baseUrl/users/reset-password');

    print('🔑 Resetting password with token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'new_password': newPassword,
        }),
      );

      print('📥 Reset Password Response Status: ${response.statusCode}');
      print('📥 Reset Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Password reset successful');
        return;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Invalid or expired token
        throw Exception('Invalid or expired token');
      } else if (response.statusCode == 404) {
        // Token not found
        throw Exception('Invalid token');
      } else if (response.statusCode == 422) {
        // Validation error
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Validation error');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print('❌ Reset password error: $e');
      rethrow;
    }
  }

  static void logout() {
    accessToken = null;
    print('🔒 User logged out, token cleared');
  }

  static bool get isLoggedIn => accessToken != null;
}