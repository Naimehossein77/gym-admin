import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Model/member_model.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:gym_admin/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreenController extends GetxController {
  TextEditingController textController = TextEditingController();
  String selectedCountryCode = '+880';
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  RxString membershipType = 'Premium'.obs;
  TextEditingController countryController = TextEditingController();
  var selectedPlan = 'Basic'.obs;

  // List of options
  final List<String> plans = ['Premium', 'Basic', 'Others'];

  var isLoading = false.obs;
  var responseMessage = ''.obs;
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMembers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var members = <MemberModel>[].obs;

  var currentPage = 0.obs;
  final int pageSize = 20;

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

  List<MemberModel> get paginatedMembers {
    final start = currentPage.value * pageSize;
    final end = start + pageSize;
    return members.sublist(start, end > members.length ? members.length : end);
  }

  void nextPage() {
    if ((currentPage.value + 1) * pageSize < members.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Member Add Function
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
      if (response.statusCode == 200) {
        responseMessage.value = 'Member added successfully!';
        print(response.body);
        Get.toNamed(Routes.dashbordScreen);
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
}
