import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class InvestmentService {
  static const String baseUrl = 'https://inrfs-be.onrender.com';

  /* ---------------- CREATE INVESTMENT + BOND ---------------- */

  static Future<Map<String, dynamic>> createInvestmentWithBond({
    required String token,
    required double principalAmount,
    required int planTypeId,
    required String maturityDate,
    required File bondFile,
  }) async {
    final uri = Uri.parse('$baseUrl/investments/');

    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'principal_amount': principalAmount.toStringAsFixed(0),
      'plan_type_id': planTypeId.toString(),
      'maturity_date': maturityDate,
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'upload_file',
        bondFile.path,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body);
    }

    return jsonDecode(body);
  }
}
