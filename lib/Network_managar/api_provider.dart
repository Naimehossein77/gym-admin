import 'dart:convert';
import 'dart:developer';
import 'package:gym_admin/Network_managar/api_constants.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';
import 'package:http/http.dart' as http;


class ApiProvider {
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = (await UserPreference.getToken())?.trim();
    log('📦 token being sent => $token');

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
 static Future<http.Response> authGet({required String endpoint}) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getAuthHeaders();
    return await http.get(url, headers: headers);
  }
  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    return await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> authPost({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getAuthHeaders();
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

 

  static Future<http.Response> authDelete({required String endpoint}) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getAuthHeaders();
    return await http.delete(url, headers: headers);
  }
  
   static Future<http.Response> authPut({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getAuthHeaders();
    return await http.put(url, headers: headers, body: jsonEncode(body));
  }

  //   static Future<http.Response> post({
  //   required String endpoint,
  //   required Map<String, dynamic> body,
  //   Map<String, String>? headers,
  // }) async {
  //   final url = Uri.parse(ApiConstants.baseUrl + endpoint);
  //   final response = await http.post(
  //     url,
  //     headers: headers ?? {'Content-Type': 'application/json'},
  //     body: jsonEncode(body),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('POST request failed: ${response.statusCode} - ${response.body}');
  //   }

  //   return response;
  // }

  // static Future<http.Response> authPost({
  //   required String endpoint,
  //   required Map<String, dynamic> body,
  // }) async {
  //   final url = Uri.parse(ApiConstants.baseUrl + endpoint);
  //   final headers = await _getAuthHeaders();
  //   final response = await http.post(
  //     url,
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Auth POST failed: ${response.statusCode} - ${response.body}');
  //   }

  //   return response;
  // }

  // static Future<http.Response> authGet({required String endpoint}) async {
  //   final url = Uri.parse(ApiConstants.baseUrl + endpoint);
  //   final headers = await _getAuthHeaders();
  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode != 200) {
  //     throw Exception('Auth GET failed: ${response.statusCode} - ${response.body}');
  //   }

  //   return response;
  // }

  // static Future<http.Response> authDelete({required String endpoint}) async {
  //   final url = Uri.parse(ApiConstants.baseUrl + endpoint);
  //   final headers = await _getAuthHeaders();
  //   final response = await http.delete(url, headers: headers);

  //   if (response.statusCode != 200) {
  //     throw Exception('Auth DELETE failed: ${response.statusCode} - ${response.body}');
  //   }

  //   return response;
  // }
}
