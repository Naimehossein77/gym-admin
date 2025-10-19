import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreenController extends GetxController {
  TextEditingController textController = TextEditingController();
  String selectedCountryCode = "+1"; 

TextEditingController countryController = TextEditingController();
  var selectedPlan = 'Basic'.obs;

  // List of options
  final List<String> plans = ['Premium', 'Basic', 'Others'];




    var isLoading = false.obs;
  var responseMessage = ''.obs;

  // TextEditingControllers (optional, যদি form থেকে নাও)
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxString membershipType = 'Premium'.obs;

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

      if (response.statusCode == 200) {
        responseMessage.value = 'Member added successfully!';
        print(response.body);
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
