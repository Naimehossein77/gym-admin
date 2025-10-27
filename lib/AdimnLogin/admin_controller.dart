
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';
import 'package:gym_admin/Utils/routes.dart';
import 'package:http/http.dart' as http;
class AdminController extends GetxController {
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  var isLoading = false.obs;
  var obscurePassword = true.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password cannot be empty");
      return;
    }

    final String url = '${ApiService.baseUrl}auth/admin/login';

    try {
      log('Login Request to $url');
      log('Payload -> username: $username, password: $password');

      // Sending data as x-www-form-urlencoded
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username.trim(),
          'password': password.trim(),
        },
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        String token = data['access_token'] ?? '';
        String role = data['role'] ?? '';

        log('Access Token: $token');
        log('Role: $role');

        await UserPreference.saveToken(token);

        Get.toNamed(Routes.dashboard);
        Get.snackbar("Success", "Login successful");
      } else {
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        String errorMsg = data['message'] ?? "Login failed";
        Get.snackbar("Error", errorMsg);
        log('Login failed: ${response.body}');
      }
    } catch (e) {
      log('Exception: $e');
      Get.snackbar("Error", "Something went wrong. Please try again.");
    }
  }
}

