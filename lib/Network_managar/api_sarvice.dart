import 'dart:convert';
import 'dart:developer';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:gym_admin/Network_managar/api_constants.dart';
import 'package:gym_admin/Network_managar/api_provider.dart';
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
   static const String baseUrl = "http://192.168.10.29:9000/api/";

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




  
  static Future<http.Response> memberAdd({
    required String name,
    required String email,
    required String phone,
    required String membershipType,
    required String token, // যদি Authorization লাগে
  }) async {
    final url = Uri.parse('$baseUrl/${ApiConstants.addMember}');

    // Body
    final body = jsonEncode({
      "name": name,
      "email": email,
      "phone": phone,
      "membership_type": membershipType,
    });

    // Headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // token optional, যদি API secure
    };

    // POST request
    final response = await http.post(url, body: body, headers: headers);

    return response;
  }
}
