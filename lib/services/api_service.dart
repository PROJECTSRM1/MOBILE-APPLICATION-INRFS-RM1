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
  // GET USER DETAILS
  // ===========================
  static Future<Map<String, dynamic>> getUserDetails({
    required String userId,
    required String token,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/$userId');

    print('🔍 Fetching user details: $url');

    final response = await http.get(
      url,
      headers: _headers(token: token),
    );

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to fetch user details');
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