import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Model/member_model.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:gym_admin/Network_managar/user_preference.dart';
import 'package:gym_admin/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreenController extends GetxController {
  var searchController = TextEditingController();
  var isLoading = false.obs;
  var members = <MemberModel>[].obs;
  var paginatedMembers = <MemberModel>[].obs;
  var currentPage = 0.obs;
  final int pageSize = 10;
  var selectedMember = Rx<MemberModel?>(null);

  void updatePaginatedMembers() {
    int startIndex = currentPage.value * pageSize;
    int endIndex =
        (startIndex + pageSize > members.length)
            ? members.length
            : startIndex + pageSize;
    if (startIndex < members.length) {
      paginatedMembers.value = members.sublist(startIndex, endIndex);
    } else {
      paginatedMembers.clear();
    }
  }

  void nextPage() {
    if ((currentPage.value + 1) * pageSize < members.length) {
      currentPage.value++;
      updatePaginatedMembers();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      updatePaginatedMembers();
    }
  }

  void credendentials() {
    Get.snackbar("Action", "Add Credential action triggered.");
  }

  void tokenGenarate() {
    Get.snackbar("Action", "Token Generate action triggered.");
  }

  TextEditingController textController = TextEditingController();
  String selectedCountryCode = '+880';
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  final expearDaysController = TextEditingController();
  RxString membershipType = 'Premium'.obs;
  TextEditingController countryController = TextEditingController();
  var selectedPlan = 'Basic'.obs;
  final DaysController = TextEditingController();
  final tokenController = TextEditingController();

  final List<String> plans = ['Premium', 'Basic', 'Others'];

  var responseMessage = ''.obs;
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMembers();
    getToken(memberId: 5);
  }

  @override
  void onClose() {
    super.onClose();
  }

  var token = ''.obs;

  Future<void> getToken({required int memberId}) async {
    try {
      isLoading(true);
      final result = await ApiService.tokenGet(memberId);

      if (result != null && result['token'] != null) {
        token.value = result['token'];
        Get.snackbar("✅ Success", "Token fetched successfully!");
      } else {
        token.value = '';
        Get.snackbar("⚠️ Failed", "No token found for this member.");
      }
    } catch (e) {
      token.value = '';
      Get.snackbar("❌ Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMembers() async {
    isLoading.value = true;
    try {
      final data = await ApiService.getMembers(); // fetch all
      members.assignAll(data);
    } catch (e) {
      print('❌ Error fetching members: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMember() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final response = await ApiService.memberAdd(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        membershipType: membershipType.value,
        token: token,
      );
      log("body:${response.body}");
      log("satuscode:${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseMessage.value = 'Member added successfully!';
        print(response.body);
        Get.back();
      } else {
        responseMessage.value = 'Failed to add member';
        print(response.body);
      }
    } catch (e) {
      responseMessage.value = 'Error: $e';
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  var isUpdatingCredentials = false.obs;

  Future<void> setPassword({
    required String username,
    required String password,
  }) async {
    try {
      isUpdatingCredentials.value = true;

      final memberId = selectedMember.value?.id;
      if (memberId == null) {
        Get.snackbar(
          "❌ Error",
          "No member selected",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final token = await UserPreference.getToken() ?? '';
      log('🔑 Token: $token');

      final response = await ApiService.setMemberCredentials(
        memberId: memberId,
        username: userNameController.text.trim(),
        password: passwordController.text.trim(),
        token: token,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        log('📦 Response body: ${response.body}');
        Get.snackbar(
          "✅ Success",
          data['message'] ?? "Credentials updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.dashbordScreen);
      } else {
        Get.snackbar(
          "❌ Error",
          data['message'] ?? "Failed to update credentials",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('❌ Exception: $e');
      Get.snackbar(
        "❌ Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingCredentials.value = false;
    }
  }

  var tokenResponse = {}.obs;













Future<void> generateTokenFromModel({
  required member,  
  required String expiresInDays,
}) async {
  try {
    isLoading(true);
    EasyLoading.show(status: "Generating token...");
    isUpdatingCredentials.value = true;

    log(" Member Info Sending:");
    log(" ID: ${member.id}");
    log(" Name: ${member.name}");

   
    final expires = int.tryParse(expiresInDays);
    if (expires == null || expires <= 0) {
      Get.snackbar(
        " Invalid Input",
        "Please enter a valid number of days",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    
    final result = await ApiService.generateToken(
      memberId: member.id,       
      expiresInDays: expires,
    );

    
    if (result != null && result['token'] != null) {
      tokenResponse.value = result;
      Get.snackbar(
        " Success",
        "Token generated successfully for ${member.name}!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "❌ Failed",
        "Could not generate token for ${member.name}.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      " Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
    if (EasyLoading.isShow) EasyLoading.dismiss();
    isUpdatingCredentials.value = false;
  }
}


  Future<void> deleteMember(int memberId) async {
    final token = await UserPreference.getToken() ?? '';
    log("$token");
    final response = await ApiService.deleteMember(targetMemberId: memberId);
    if (response.statusCode == 200) {
      members.removeWhere((m) => m.id == memberId);
      Get.snackbar(
        "Deleted",
        "Member removed successfully",
        backgroundColor: Colors.green,
      );
      fetchMembers();
    } else {
      Get.snackbar(
        "Error",
        "Failed to delete member",
        backgroundColor: Colors.red,
      );
    }
  }
}
