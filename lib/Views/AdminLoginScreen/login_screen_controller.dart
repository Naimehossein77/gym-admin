import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:gym_admin/Utils/routes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// // Routes.dart
// class Routes {
//   static const dashbordScreen = "/dashboard";
// }

// Controller
class AdminLoginScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  // Controller permanent create
  static AdminLoginScreenController get to =>
      Get.find<AdminLoginScreenController>();

  @override
  void onInit() {
    super.onInit();
  }

  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> adminUserLogin() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        "Validation Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      EasyLoading.show(status: "Logging in...");
      final response = await ApiService.adminLogin(
        username: userNameController.text,
        password: passwordController.text,
      );
      log("statuscode:${response.statusCode}");
      log("body:${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final role = data["role"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
        await prefs.setString('role', role);
        log('✅ Token saved successfully!');
        if (token != null) {
          log("$token");
          log("$role");
          log("$data");
          Get.snackbar(
            "Success",
            "Login Successful",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          EasyLoading.dismiss();
        }
        Get.offAllNamed(Routes.dashbordScreen);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log("Login Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
