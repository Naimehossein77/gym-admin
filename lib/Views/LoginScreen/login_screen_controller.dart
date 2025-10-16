import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';
import 'package:gym_admin/Utils/routes.dart';

class LoginScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  // void login() {
  //   if (formKey.currentState!.validate()) {
  //     Get.toNamed(Routes.dashbordScreen);
  //     Get.snackbar(
  //       "Success",
  //       "Login Successful!",
  //       backgroundColor: Colors.green.withOpacity(0.2),
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } else {
  //     Get.snackbar(
  //       "Error",
  //       "Please fill all fields correctly",
  //       backgroundColor: Colors.red.withOpacity(0.2),
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }
  Future<void> adminLogin() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        "Validation Error",
        "Please fill all fields correctly",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      EasyLoading.show(status: "Logging in...");

      // ✅ form data keys must match the API ("username", "password")
      final body = {
        'username': userNameController.text.trim(),
        'password': passwordController.text.trim(),
      };

      final response = await ApiService.addminLogin({
        'username': userNameController.text.trim(),
        'password': passwordController.text.trim(),
      });
      EasyLoading.dismiss();
      log("statuscode: ${response.statusCode}");
      log("body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final token = decoded['access_token'];
        final role = decoded['role'];

        if (token != null && token is String) {
          await UserPreference.saveToken(token);
          await UserPreference.saveUserName(userNameController.text.trim());
          await UserPreference.saveIsLoggedIn(true);

          Get.snackbar(
            "Success",
            "Login Successful",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          if (role == "admin") {
            Get.offAllNamed(Routes.dashbordScreen);
          }
        } else {
          throw Exception("Invalid token received.");
        }
      } else {
        final decoded = jsonDecode(response.body);
        final detail = decoded['detail'] ?? "Unknown error";

        Get.snackbar(
          "Login Failed",
          "$detail",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      log("❌ Login Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
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
