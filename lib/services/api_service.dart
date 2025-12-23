// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const baseUrl = 'http://10.0.2.2:8000';

//   static Future<String> registerUser({
//     required String name,
//     required String email,
//     required String mobile,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'mobile': mobile,
//       }),
//     );

//     final data = jsonDecode(response.body);
//     return data['investor_id'];
//   }
// }
