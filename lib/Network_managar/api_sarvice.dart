import 'dart:developer';
import 'package:gym_admin/Network_managar/user_preference.dart';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = (await UserPreference.getToken())?.trim();
    log('📦 token being sent => $token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// 🔹 Admin Login API Call
   static const String baseUrl = "http://192.168.10.10:8000/api/";

  /// Admin login (x-www-form-urlencoded)
  static Future<http.Response> adminLogin({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${baseUrl}auth/admin/login");

      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
      };

      final body = {
        "username": username.trim(),
        "password": password.trim(),
      };

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode != 200) {
        throw Exception('Login failed: ${response.statusCode}');
      }
      return response;
    } catch (e) {
      log('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }
}
