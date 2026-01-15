// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  static String? accessToken;
  static String? _passwordResetToken; // Internal storage for reset token

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
  /// Throws exception if email sending fails or email not registered
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your connection.');
        },
      );

      print('📥 Forgot Password Response Status: ${response.statusCode}');
      print('📥 Forgot Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Success - email was actually sent
        print('✅ Password reset email sent successfully');
        
        // Verify the response contains success confirmation
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null && 
              data['message'].toString().toLowerCase().contains('sent')) {
            return; // Email confirmed sent
          }
        } catch (e) {
          print('⚠️ Could not parse response body, but status 200 received');
        }
        return;
      } else if (response.statusCode == 404) {
        // Email not found/not registered
        throw Exception('Email not registered');
      } else if (response.statusCode == 422) {
        // Validation error
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Invalid email format');
        } catch (e) {
          throw Exception('Invalid email format');
        }
      } else if (response.statusCode == 500) {
        // Server error - email sending likely failed
        try {
          final error = jsonDecode(response.body);
          final detail = error['detail'] ?? 'Server error';
          
          // Check if it's specifically an email sending error
          if (detail.toString().toLowerCase().contains('email') ||
              detail.toString().toLowerCase().contains('smtp')) {
            throw Exception('Failed to send email. Please try again later.');
          }
          throw Exception(detail);
        } catch (e) {
          if (e.toString().contains('Failed to send email')) {
            rethrow;
          }
          throw Exception('Server error. Please try again later.');
        }
      } else if (response.statusCode == 400) {
        // Bad request
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Bad request');
        } catch (e) {
          throw Exception('Email not registered');
        }
      } else {
        // Other errors
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Failed to send reset email');
        } catch (e) {
          throw Exception('Failed to send reset email');
        }
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException {
      print('❌ Network error: Client exception');
      throw Exception('Network error. Please try again.');
    } catch (e) {
      print('❌ Request password reset error: $e');
      rethrow;
    }
  }

  /// Store reset token internally (from deep link)
  static void setResetToken(String token) {
    _passwordResetToken = token;
    print('🔑 Reset token stored internally');
  }

  /// Reset password using internally stored token
  static Future<void> resetPassword(String newPassword) async {
    if (_passwordResetToken == null || _passwordResetToken!.isEmpty) {
      throw Exception('No reset token available. Please request a new reset link.');
    }

    final Uri url = Uri.parse('$baseUrl/users/reset-password');

    print('🔑 Resetting password with stored token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': _passwordResetToken,
          'new_password': newPassword,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('📥 Reset Password Response Status: ${response.statusCode}');
      print('📥 Reset Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Password reset successful');
        _passwordResetToken = null; // Clear token after successful reset
        return;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Invalid or expired token
        _passwordResetToken = null; // Clear invalid token
        throw Exception('Invalid or expired token');
      } else if (response.statusCode == 404) {
        // Token not found
        _passwordResetToken = null;
        throw Exception('Invalid token');
      } else if (response.statusCode == 422) {
        // Validation error
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Validation error');
        } catch (e) {
          throw Exception('Validation error');
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Failed to reset password');
        } catch (e) {
          throw Exception('Failed to reset password');
        }
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection');
    } catch (e) {
      print('❌ Reset password error: $e');
      rethrow;
    }
  }

  static void logout() {
    accessToken = null;
    _passwordResetToken = null;
    print('🔒 User logged out, tokens cleared');
  }

  static bool get isLoggedIn => accessToken != null;
  
  static bool get hasResetToken => _passwordResetToken != null && _passwordResetToken!.isNotEmpty;
}