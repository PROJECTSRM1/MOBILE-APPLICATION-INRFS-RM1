// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
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
  // REGISTER USER
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
        "role_id": 1,
        "gender_id": 1,
        "age": 25,
        "dob": "1999-01-01"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Registration failed');
    }
  }

  // ===========================
  // VERIFY OTP
  // ===========================
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/verify-otp');

    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Invalid OTP');
    }
  }

  // ===========================
  // RESEND OTP
  // ===========================
  static Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/resend-otp?email=$email');

    print('📧 Resending OTP to: $email');
    print('🔍 Request URL: $url');

    try {
      final response = await http.post(
        url,
        headers: _headers(),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your connection.');
        },
      );

      print('📥 Resend OTP Response Status: ${response.statusCode}');
      print('📥 Resend OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ OTP resent successfully');
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Email not registered');
      } else if (response.statusCode == 400) {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Invalid request');
        } catch (e) {
          throw Exception('Failed to resend OTP');
        }
      } else if (response.statusCode == 422) {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Invalid email format');
        } catch (e) {
          throw Exception('Invalid email format');
        }
      } else if (response.statusCode == 429) {
        throw Exception('Too many OTP requests. Please wait before trying again.');
      } else if (response.statusCode == 500) {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Server error. Please try again later.');
        } catch (e) {
          throw Exception('Server error. Please try again later.');
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Failed to resend OTP');
        } catch (e) {
          throw Exception('Failed to resend OTP');
        }
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException {
      print('❌ Network error: Client exception');
      throw Exception('Network error. Please try again.');
    } catch (e) {
      print('❌ Resend OTP error: $e');
      rethrow;
    }
  }

  // ===========================
  // GET USER DETAILS BY INV_REG_ID
  // ===========================
  static Future<Map<String, dynamic>> getUserDetails({
    required String invRegId,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/$invRegId');

    print('🔍 Fetching user details for inv_reg_id: $invRegId');
    print('🔍 Request URL: $url');

    try {
      final response = await http.get(
        url,
        headers: _headers(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ User details fetched successfully');
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to fetch user details');
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection');
    } catch (e) {
      print('❌ Get user details error: $e');
      rethrow;
    }
  }

  // ===========================
  // UPDATE USER DETAILS
  // ===========================
  static Future<Map<String, dynamic>> updateUserDetails({
    required String invRegId,
    required String token,
    String? firstName,
    String? lastName,
    String? mobile,
    int? genderId,
    String? dob,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/$invRegId');

    final Map<String, dynamic> body = {};
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (mobile != null) body['mobile'] = mobile;
    if (genderId != null) body['gender_id'] = genderId;
    if (dob != null) body['dob'] = dob;

    print('🔍 Updating user details for inv_reg_id: $invRegId');
    print('📤 Request body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        url,
        headers: _headers(token: token),
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ User details updated successfully');
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to update user details');
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection');
    } catch (e) {
      print('❌ Update user details error: $e');
      rethrow;
    }
  }

  // ===========================
  // DELETE USER ACCOUNT
  // ===========================
  static Future<Map<String, dynamic>> deleteUserAccount({
    required String invRegId,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/$invRegId');

    print('🔍 Deleting user account for inv_reg_id: $invRegId');

    try {
      final response = await http.delete(
        url,
        headers: _headers(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ User account deleted successfully');
        return {'message': 'Account deleted successfully'};
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to delete account');
      }
    } on SocketException {
      print('❌ Network error: No internet connection');
      throw Exception('No internet connection');
    } catch (e) {
      print('❌ Delete account error: $e');
      rethrow;
    }
  }
// ===========================
// DELETE INVESTMENT (WITHDRAW)
// ===========================
static Future<void> deleteInvestment({
  required String ukInvId,
  required String token,
}) async {
  final Uri url = Uri.parse('$baseUrl/investments/$ukInvId');

  print('🗑️ Deleting investment: $ukInvId');
  print('🔍 Request URL: $url');

  try {
    final response = await http.delete(
      url,
      headers: _headers(token: token),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Request timeout. Please try again.');
      },
    );

    print('📥 Delete Response Status: ${response.statusCode}');
    print('📥 Delete Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('✅ Investment deleted successfully');
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Investment not found');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to delete investment');
      } catch (_) {
        throw Exception('Failed to delete investment');
      }
    }
  } on SocketException {
    print('❌ Network error: No internet connection');
    throw Exception('No internet connection');
  } catch (e) {
    print('❌ Delete investment error: $e');
    rethrow;
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
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Investment creation failed');
    }
  }

  // ===========================
  // GET MY INVESTMENTS
  // ===========================
  static Future<List<dynamic>> getMyInvestments({
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/investments/my');

    print('🔍 Fetching investments from: $url');

    final response = await http.get(
      url,
      headers: _headers(token: token),
    );

    print('📥 Investments Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data is List) {
        print('✅ Found ${data.length} investments');
        return data;
      } else if (data is Map && data.containsKey('investments')) {
        final investments = data['investments'] as List<dynamic>;
        print('✅ Found ${investments.length} investments');
        return investments;
      }
      return [];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to fetch investments');
    }
  }

  // ===========================
  // GET MY PROFILE
  // ===========================
  static Future<Map<String, dynamic>> getMyProfile({
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/users/me');

    final response = await http.get(
      url,
      headers: _headers(token: token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode}',
      );
    }
  }

  // ===========================
  // GET BANK DETAILS
  // ===========================
  static Future<Map<String, dynamic>?> getBankDetails({
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    print('🔍 Fetching bank details from: $url');
    print('🔑 Using token: ${token.substring(0, 20)}...');

    try {
      final response = await http.get(
        url,
        headers: _headers(token: token),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data == null || (data is Map && data.isEmpty)) {
          print('✅ No bank details found');
          return null;
        }
        
        if (data is Map<String, dynamic>) {
          return data;
        }
        
        return null;
      } else if (response.statusCode == 404) {
        print('ℹ️ No bank details found (404)');
        return null;
      } else {
        print('❌ Failed to fetch bank details: ${response.statusCode}');
        throw Exception('Failed to fetch bank details: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching bank details: $e');
      rethrow;
    }
  }

  // ===========================
  // ADD BANK DETAILS
  // ===========================
  static Future<Map<String, dynamic>> addBankDetails({
    required int bankId,
    required String bankAccountNo,
    required String ifscCode,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    final Map<String, dynamic> requestBody = {
      "bank_id": bankId,
      "bank_account_no": bankAccountNo,
      "ifsc_code": ifscCode,
    };

    print('🔍 Adding bank details to: $url');
    print('🔑 Using token: ${token.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        url,
        headers: _headers(token: token),
        body: jsonEncode(requestBody),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Bank details added successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['detail'] ?? 'Failed to add bank details';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception adding bank details: $e');
      rethrow;
    }
  }

  // ===========================
  // UPDATE BANK DETAILS
  // ===========================
  static Future<Map<String, dynamic>> updateBankDetails({
    required int bankId,
    required String bankAccountNo,
    required String ifscCode,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    final Map<String, dynamic> requestBody = {
      "bank_id": bankId,
      "bank_account_no": bankAccountNo,
      "ifsc_code": ifscCode,
    };

    print('🔍 Updating bank details at: $url');
    print('🔑 Using token: ${token.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.put(
        url,
        headers: _headers(token: token),
        body: jsonEncode(requestBody),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Bank details updated successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['detail'] ?? 'Failed to update bank details';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception updating bank details: $e');
      rethrow;
    }
  }
}