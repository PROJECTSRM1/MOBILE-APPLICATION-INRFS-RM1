// lib/services/profile_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bank_model.dart';

class ProfileService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';
  final String authToken;

  ProfileService({required this.authToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

  Future<Map<String, dynamic>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    int? genderId,
    int? age,
    String? dob,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/me');

    final Map<String, dynamic> requestBody = {};

    if (firstName != null) requestBody['first_name'] = firstName;
    if (lastName != null) requestBody['last_name'] = lastName;
    if (email != null) requestBody['email'] = email;
    if (mobile != null) requestBody['mobile'] = mobile;
    if (genderId != null) requestBody['gender_id'] = genderId;
    if (age != null) requestBody['age'] = age;
    if (dob != null) requestBody['dob'] = dob;

    print('🔍 Updating user profile at: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Profile updated successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['detail'] ?? 'Failed to update profile';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception updating profile: $e');
      rethrow;
    }
  }

  Future<BankModel?> getBankDetails() async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    print('🔍 Fetching bank details from: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');

    try {
      final response = await http.get(url, headers: _headers);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null || (data is Map && data.isEmpty)) {
          print('✅ No bank details found');
          return null;
        }

        if (data is Map<String, dynamic>) {
          return BankModel.fromJson(data);
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

  Future<Map<String, dynamic>> addBankDetails(BankModel bank) async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    print('🔍 Adding bank details to: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(bank.toJson())}');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(bank.toJson()),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Bank details added successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage =
            error['detail'] ?? 'Failed to add bank details';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception adding bank details: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBankDetails(BankModel bank) async {
    final Uri url = Uri.parse('$baseUrl/users/bank-details');

    print('🔍 Updating bank details at: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(bank.toJson())}');

    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(bank.toJson()),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Bank details updated successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage =
            error['detail'] ?? 'Failed to update bank details';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception updating bank details: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getSupportTickets() async {
    final Uri url = Uri.parse('$baseUrl/support/tickets');

    print('🔍 Fetching support tickets from: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');

    try {
      final response = await http.get(url, headers: _headers);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          print('✅ Found ${data.length} tickets');
          return data;
        } else if (data is Map && data.containsKey('tickets')) {
          final tickets = data['tickets'] as List<dynamic>;
          print('✅ Found ${tickets.length} tickets');
          return tickets;
        }

        return [];
      } else {
        final error = jsonDecode(response.body);
        final errorMessage =
            error['detail'] ?? 'Failed to fetch support tickets';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception fetching support tickets: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createSupportTicket({
    required String subject,
    required String description,
    String? category,
  }) async {
    final Uri url = Uri.parse('$baseUrl/support/tickets');

    final Map<String, dynamic> requestBody = {
      'subject': subject,
      'description': description,
      if (category != null) 'category': category,
    };

    print('🔍 Creating support ticket at: $url');
    print('🔑 Using token: ${authToken.substring(0, 20)}...');
    print('📤 Request body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Support ticket created successfully');
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage =
            error['detail'] ?? 'Failed to create support ticket';
        print('❌ Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception creating support ticket: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    print('🔒 Logging out user...');
    print('✅ Logout successful');
  }
}
