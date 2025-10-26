import 'dart:convert';
import 'dart:developer';
import 'package:gym_admin/Models/member_model.dart';
import 'package:gym_admin/Models/member_with_token.dart';
import 'package:gym_admin/Models/members_token.dart';
import 'package:gym_admin/Models/token_expair_model.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';
import 'package:gym_admin/Utils/basic.dart';
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

  static const String baseUrl = "http://192.168.10.29:8000/api/";

  
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

      final body = {"username": username.trim(), "password": password.trim()};
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

  /// ✅ Add Member (POST /api/members)
  static Future<Member> addMember(MemberCreateRequest payload) async {
    final url = Uri.parse("${baseUrl}members");
    final headers = await _getAuthHeaders();

    try {
      final resp = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload.toJson()),
      );

      log('🔵 addMember status: ${resp.statusCode}');
      log('🟢 addMember body: ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return Member.fromJson(data);
      }
      String message = 'Add member failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      log('❌ addMember error: $e');
      rethrow;
    }
  }

  /// ✅ GET /api/members  → Fetch all members
  static Future<List<Member>> getMembers() async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse("${baseUrl}members");

    try {
      final resp = await http.get(uri, headers: headers);
      log('🔵 getMembers status: ${resp.statusCode}');
      log('🟢 getMembers body: ${resp.body}');

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);

        if (decoded is List) {
          // API returns: [ {...}, {...} ]
          return decoded.map<Member>((e) => Member.fromJson(e)).toList();
        } else if (decoded is Map && decoded['items'] is List) {
          // API returns: { items: [ {...}, {...} ] }
          return (decoded['items'] as List)
              .map<Member>((e) => Member.fromJson(e))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      }

      // Handle server error message
      String message = 'Fetch members failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      log('❌ getMembers error: $e');
      rethrow;
    }
  }

  /// ✅ Set/Update a member's credentials
  /// POST /api/members/{memberId}/credentials
  static Future<BasicResponse> setMemberCredentials({
    required int memberId,
    required String username,
    required String password,
  }) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse("${baseUrl}members/$memberId/credentials");

    final body = jsonEncode({
      "username": username.trim(),
      "password": password.trim(),
    });

    try {
      final resp = await http.post(url, headers: headers, body: body);
      log('🔵 setMemberCredentials status: ${resp.statusCode}');
      log('🟢 setMemberCredentials body: ${resp.body}');

      // সাধারণত 200 OK
      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map<String, dynamic>) {
          return BasicResponse.fromJson(decoded);
        }
        // fallback
        return BasicResponse(success: true, message: 'Credentials set.');
      }

      // সার্ভারের error মেসেজ দেখানোর চেষ্টা
      String message = 'Set credentials failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      log('❌ setMemberCredentials error: $e');
      rethrow;
    }
  }

  /// ✅ Generate NFC/Access token for a member
  /// POST /api/tokens/generate
  static Future<MemberTokenResponse> generateMemberToken({
    required int memberId,
    int expiresInDays = 30,
  }) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse("${baseUrl}tokens/generate");

    final body = jsonEncode({
      "member_id": memberId,
      "expires_in_days": expiresInDays,
    });

    try {
      final resp = await http.post(url, headers: headers, body: body);
      log('🔵 generateMemberToken status: ${resp.statusCode}');
      log('🟢 generateMemberToken body: ${resp.body}');

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map<String, dynamic>) {
          return MemberTokenResponse.fromJson(decoded);
        }
        throw Exception('Unexpected response format');
      }

      // server error message forward
      String message = 'Generate token failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      log('❌ generateMemberToken error: $e');
      rethrow;
    }
  }

  /// ✅ Delete Member API
  /// DELETE /api/members/{memberId}
/// ✅ Delete Member API
/// DELETE /api/members/{memberId}
static Future<BasicResponse> deleteMember(int memberId) async {
  final headers = await _getAuthHeaders();
  final url = Uri.parse("${baseUrl}members/$memberId");

  try {
    final resp = await http.delete(url, headers: headers);
    log('🔵 deleteMember status: ${resp.statusCode}');
    log('🟢 deleteMember body: ${resp.body}');

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map<String, dynamic>) {
        return BasicResponse.fromJson(decoded);
      } else {
        throw Exception('Unexpected response format');
      }
    }

    // Error handler
    String message = 'Delete failed (${resp.statusCode})';
    try {
      final err = jsonDecode(resp.body);
      if (err is Map && err['message'] != null) {
        message = err['message'].toString();
      }
    } catch (_) {}
    throw Exception(message);
  } catch (e) {
    log('❌ deleteMember error: $e');
    rethrow;
  }
}


  /// ✅ Update Member
  /// PUT /api/members/{memberId}
  static Future<Member> updateMember(
    int memberId, {
    String? name,
    String? email,
    String? phone,
    String? membershipType,
    String? status,
  }) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse("${baseUrl}members/$memberId");

    // কেবল যেগুলো non-null, সেগুলোই পাঠাই
    final Map<String, dynamic> payload = {};
    if (name != null) payload["name"] = name.trim();
    if (email != null) payload["email"] = email.trim();
    if (phone != null) payload["phone"] = phone.trim();
    if (membershipType != null)
      payload["membership_type"] = membershipType.trim();
    if (status != null) payload["status"] = status.trim();

    if (payload.isEmpty) {
      throw Exception("Nothing to update. Provide at least one field.");
    }

    try {
      final resp = await http.put(
        url,
        headers: headers,
        body: jsonEncode(payload),
      );

      log('🔵 updateMember status: ${resp.statusCode}');
      log('🟢 updateMember body: ${resp.body}');

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map<String, dynamic>) {
          return Member.fromJson(decoded);
        }
        throw Exception('Unexpected response format');
      }

      // সার্ভারের error বার্তা forward
      String message = 'Update failed (${resp.statusCode})';
      try {
        final err = jsonDecode(resp.body);
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      log('❌ updateMember error: $e');
      rethrow;
    }
  }

  // GET /api/members/admin/members-with-tokens
static Future<List<MemberWithToken>> getMembersWithTokens() async {
  final headers = await _getAuthHeaders();
  final url = Uri.parse("${baseUrl}members/admin/members-with-tokens");

  try {
    final resp = await http.get(url, headers: headers);
    log('🔵 getMembersWithTokens status: ${resp.statusCode}');
    log('🟢 getMembersWithTokens body: ${resp.body}');

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);

      if (decoded is List) {
        return decoded
            .map<MemberWithToken>((e) => MemberWithToken.fromJson(e))
            .toList();
      }
      throw Exception('Unexpected response format');
    }

    // সার্ভারের error মেসেজ ফরওয়ার্ড করার চেষ্টা
    String message = 'Fetch members-with-tokens failed (${resp.statusCode})';
    try {
      final err = jsonDecode(resp.body);
      if (err is Map && err['message'] != null) {
        message = err['message'].toString();
      }
    } catch (_) {}
    throw Exception(message);
  } catch (e) {
    log('❌ getMembersWithTokens error: $e');
    rethrow;
  }
}

/// ✅ Cleanup expired tokens
/// POST /api/tokens/cleanup
static Future<TokenCleanupResponse> cleanupExpiredTokens() async {
  final headers = await _getAuthHeaders();
  final url = Uri.parse("${baseUrl}tokens/cleanup");

  try {
    final resp = await http.post(url, headers: headers, body: jsonEncode({}));
    log('🔵 cleanupExpiredTokens status: ${resp.statusCode}');
    log('🟢 cleanupExpiredTokens body: ${resp.body}');

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map<String, dynamic>) {
        return TokenCleanupResponse.fromJson(decoded);
      }
      throw Exception('Unexpected response format');
    }

    // forward server message if any
    String message = 'Cleanup failed (${resp.statusCode})';
    try {
      final err = jsonDecode(resp.body);
      if (err is Map && err['message'] != null) {
        message = err['message'].toString();
      }
    } catch (_) {}
    throw Exception(message);
  } catch (e) {
    log('❌ cleanupExpiredTokens error: $e');
    rethrow;
  }
}
}
