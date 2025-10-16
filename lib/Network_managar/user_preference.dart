import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static const _kProfileDone = 'profile_done';
  static const _kProfileData = 'profile_data';

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<void> saveRememberMe(bool stay) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('RememberMe', stay);
  }

  static Future<bool> getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('RememberMe') ?? false;
  }

  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
  }

  static Future<void> saveIsLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> saveProfileDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kProfileDone, value);
  }

  static Future<bool> isProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kProfileDone) ?? false;
  }

  static Future<void> cacheProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfileData, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_kProfileData);
    return (str == null) ? null : jsonDecode(str) as Map<String, dynamic>;
  }
    static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
  }

  /// 🔹 Get userName
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }
}


