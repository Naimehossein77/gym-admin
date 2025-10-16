import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Utils/routes.dart';
import 'package:gym_admin/Views/LoginScreen/login_Screen_controller.dart';

class LoginScreenBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>LoginScreenController());
  }

}