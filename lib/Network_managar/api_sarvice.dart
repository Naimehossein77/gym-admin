import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:gym_admin/Network_managar/api_constants.dart';
import 'package:gym_admin/Network_managar/api_provider.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';

class ApiService {
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = (await UserPreference.getToken())?.trim();
    log('📦 token being sent => $token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response>addminLogin(Map<String, dynamic> body) {
    return ApiProvider.post(endpoint: ApiConstants.AdminLogin, body: body);
  }
}
