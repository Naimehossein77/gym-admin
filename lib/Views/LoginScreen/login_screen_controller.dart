import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Utils/routes.dart';

class LoginScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(Routes.dashbordScreen);
      Get.snackbar(
        "Success",
        "Login Successful!",
        backgroundColor: Colors.green.withOpacity(0.2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill all fields correctly",
        backgroundColor: Colors.red.withOpacity(0.2),
        snackPosition: SnackPosition.BOTTOM,
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