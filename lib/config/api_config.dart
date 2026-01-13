// lib/config/api_config.dart

class ApiConfig {
  static const String baseUrl = 'https://inrfs-be.onrender.com';
  
  // User endpoints
  static const String users = '/users';
  static String userById(String userId) => '/users/$userId';
  static const String userMe = '/users/me';
  
  // Bank endpoints
  static const String bankDetails = '/users/bank-details';
  
  // Support endpoints
  static const String supportTickets = '/support/tickets';
  
  // Document endpoints
  static const String documents = '/users/documents';
  
  // Headers
  static Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}