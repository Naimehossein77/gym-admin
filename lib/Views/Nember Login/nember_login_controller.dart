import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NemberLoginController extends GetxController{
  
 final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

}