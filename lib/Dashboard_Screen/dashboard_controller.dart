import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http show delete, get, post;

// lib/models/member_model.dart
class Member {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String membershipType;
  final String status;
  final String username;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.membershipType,
    required this.status,
    required this.username,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      membershipType: json['membership_type'] ?? '',
      status: json['status'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class DashboardController extends GetxController {
  // ✅ ScrollControllers আলাদা ভাবে তৈরি
  final verticalController = ScrollController();
  final horizontalController = ScrollController();
  // final ScrollController scrollController = ScrollController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var obscurePassword = true.obs;
  var isLoading = false.obs;

  var members = <Member>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchMembers(); // load existing members
  //   // now works
  // }
  final String baseUrl = "http://192.168.10.29:8000/api/members";
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInVpZCI6MSwiZXhwIjoxNzYxNjQxOTMxfQ.sUp_R8XghwGgrOFK2l2Z0Mw6mb-QC4dOd1BzI9u8CFE";

  // final RxList<Member> members = <Member>[].obs;
  // final RxBool isLoading = false.obs;

  // final ScrollController scrollController = ScrollController();

  // Pagination State
  final int limit = 20;
  // final RxInt currentPage = 1.obs;
  // final RxInt totalPages = 1.obs;
  final RxInt currentPage = 1.obs;
  final int totalPages = 5; // তোমার API অনুযায়ী change করতে পারো

  @override
  void onInit() {
    super.onInit();
    fetchMembers(page: 1);
  }

  Future<void> fetchMembers({required int page}) async {
    try {
      isLoading.value = true;

      final int limit = 20;
      final int skip = (page - 1) * limit;

      final response = await http.get(
        Uri.parse("$baseUrl/?skip=$skip&limit=$limit"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      log("Fetch statusCode: ${response.statusCode}");
      log("Fetch body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        members.assignAll(data.map((e) => Member.fromJson(e)).toList());
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch members: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Add Member Function
  Future<void> addMember(Map<String, dynamic> memberData) async {
    final String baseUrl = "http://192.168.10.29:8000/api/members";
    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInVpZCI6MSwiZXhwIjoxNzYxNjQxOTMxfQ.sUp_R8XghwGgrOFK2l2Z0Mw6mb-QC4dOd1BzI9u8CFE";

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(memberData),
      );

      log("statusCode:${response.statusCode}");
      log("Body:${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close popup
        Get.snackbar(
          "Success",
          "Member added successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );

        // ✅ API থেকে নতুন member JSON রিটার্ন করছে ধরে নিয়ে add করো
        final newMemberJson = jsonDecode(response.body);
        final newMember = Member.fromJson(newMemberJson);

        // List-এর শুরুতে insert
        members.insert(0, newMember);
        members.refresh(); // UI refresh
      } else {
        Get.snackbar(
          "Error",
          "Failed to add member: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE53935),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // DeleteMember API

  Future<void> deleteMembers(int memberId) async {
    final String baseUrl = "http://192.168.10.29:8000/api/members/$memberId";
    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInVpZCI6MSwiZXhwIjoxNzYxNjQxOTMxfQ.sUp_R8XghwGgrOFK2l2Z0Mw6mb-QC4dOd1BzI9u8CFE";

    try {
      isLoading.value = true;

      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        // ✅ তোমার API যদি token ও member_id চায় তাহলে body সহ পাঠাও:
        body: jsonEncode({
          "token": "DwQYYu9FkwNsc4mHhsOo0kwET6tF1HhG",
          "member_id": memberId,
        }),
      );

      log("DELETE statusCode: ${response.statusCode}");
      log("DELETE response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);

        if (result["success"] == true) {
          Get.snackbar(
            "Deleted",
            "Member deleted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // ✅ লোকাল লিস্ট থেকেও ডিলিট করা
          members.removeWhere((member) => member.id == memberId);
          members.refresh();

          // ✅ অথবা সার্ভার থেকে রিফ্রেশ করতে চাও
          // await fetchMembers();
        } else {
          Get.snackbar(
            "Error",
            "Failed: ${result["message"]}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server Error: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Call this from screen to show popup
  void showAdminPopup(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final RxString selectedMembership = 'Premium'.obs;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: const Color.fromARGB(255, 59, 59, 59),
          child: Container(
            width: 100.w,
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Member",
                    style: TextStyle(
                      fontSize: 6.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 101, 139, 158),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // ✅ Name
                  _customTextField(
                    controller: nameController,
                    hint: "Enter member name",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 3.h),

                  // ✅ Email
                  _customTextField(
                    controller: emailController,
                    hint: "Enter email address",
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 3.h),

                  // ✅ Phone
                  _customTextField(
                    controller: phoneController,
                    hint: "Enter phone number",
                    icon: Icons.phone_outlined,
                  ),
                  SizedBox(height: 3.h),

                  // ✅ Membership Type
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<String>(
                        value: selectedMembership.value,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blueGrey[700],
                        ),
                        items:
                            ['Basic', 'Standard', 'Premium'].map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontSize: 3.5.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedMembership.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // ✅ Submit Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 36.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLoading.value
                                  ? Colors.grey
                                  : Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            isLoading.value
                                ? null
                                : () {
                                  // TODO: Replace this with your API function
                                  addMember({
                                    "name": nameController.text.trim(),
                                    "email": emailController.text.trim(),
                                    "phone": phoneController.text.trim(),
                                    "membership_type": selectedMembership.value,
                                  });
                                },
                        child:
                            isLoading.value
                                ? SizedBox(
                                  height: 15.h,
                                  width: 12.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Add Member",
                                  style: TextStyle(
                                    fontSize: 3.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ Reusable TextField Widget
  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        style: TextStyle(color: Colors.black, fontSize: 4.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blueGrey[700]) : null,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blueGrey[700] ?? Colors.blueGrey,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        ),
      ),
    );
  } // Add Credential PopUp

  void showCredentialPopup(BuildContext context, int memberId) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final RxBool obscure = true.obs; // ✅ এখানে রাখবে

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: const Color.fromARGB(255, 35, 35, 35),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 100.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Member Credential",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ✅ Username Field
                  TextField(
                    controller: usernameController,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter username",
                      // prefixIcon: const Icon(Icons.person_outline, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Password Field (with show/hide button)
                  // Declare outside Obx (popup builder এর শুরুতে)
                  // final RxBool obscure = true.obs;
                  Obx(
                    () => TextField(
                      controller: passwordController,
                      obscureText: obscure.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter password",
                        // prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.blueGrey,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {
                            obscure.value = !obscure.value;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ✅ Submit Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading.value
                                ? null
                                : () {
                                  addCredential(
                                    memberId,
                                    usernameController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            isLoading.value
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                                : const Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // var members = <Member>[].obs;
  void addCredential(int memberId, String username, String password) async {
    final String baseUrl =
        "http://192.168.10.29:8000/api/members/$memberId/credentials";
    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInVpZCI6MSwiZXhwIjoxNzYxNjQxOTMxfQ.sUp_R8XghwGgrOFK2l2Z0Mw6mb-QC4dOd1BzI9u8CFE";

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Token যোগ করো
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      log("Credential statusCode: ${response.statusCode}");
      log("Credential response: ${response.body}");

      if (response.statusCode == 200) {
        Get.back(); // ✅ Popup বন্ধ করো

        // ✅ UI তে username update করো
        int index = members.indexWhere((m) => m.id == memberId);
        if (index != -1) {
          final oldMember = members[index];

          members[index] = Member(
            id: oldMember.id,
            name: oldMember.name,
            email: oldMember.email,
            phone: oldMember.phone,
            membershipType: oldMember.membershipType,
            status: oldMember.status,
            username: username, // ✅ নতুন username
          );

          members.refresh(); // ✅ UI refresh
        }

        Get.snackbar(
          "Success",
          "Credential added successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final body = jsonDecode(response.body);
        final message = body["detail"] ?? "Failed to add credential";
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Token Genaret Function

  void showTokenPopup(BuildContext context, int memberId) {
    final TextEditingController daysController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: const Color.fromARGB(255, 49, 49, 49),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: 100.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Generate Token",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Input field for expires_in_days
                  TextField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Expires in (days)",
                      hintText: "Enter number of days (e.g. 30)",
                      prefixIcon: const Icon(Icons.timer_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ✅ Submit button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed:
                            isLoading.value
                                ? null
                                : () {
                                  final days = int.tryParse(
                                    daysController.text,
                                  );
                                  if (days == null || days <= 0) {
                                    Get.snackbar(
                                      "Error",
                                      "Please enter a valid number of days.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  generateToken(memberId, days);
                                },
                        icon:
                            isLoading.value
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.vpn_key_outlined),
                        label: Text(
                          isLoading.value ? "Generating..." : "Generate Token",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // var memberTokens = <int, String>{}.obs; // 👈 প্রতিটি member-এর জন্য আলাদা token

  final RxMap<int, String> generatedTokens = <int, String>{}.obs;

  Future<void> generateToken(int memberId, int expiresInDays) async {
    final String baseUrl = "http://192.168.10.29:8000/api/tokens/generate";
    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInVpZCI6MSwiZXhwIjoxNzYxNjQxOTMxfQ.sUp_R8XghwGgrOFK2l2Z0Mw6mb-QC4dOd1BzI9u8CFE";

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "member_id": memberId,
          "expires_in_days": expiresInDays,
        }),
      );

      log("Token statusCode: ${response.statusCode}");
      log("Token response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tokenValue = data["token"] ?? "N/A";

        // ✅ নির্দিষ্ট memberId অনুযায়ী token সংরক্ষণ করো
        generatedTokens[memberId] = tokenValue;
        generatedTokens.refresh();

        Get.back(); // popup বন্ধ করো

        Get.snackbar(
          "Success",
          "Token generated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final body = jsonDecode(response.body);
        final message = body["detail"] ?? "Failed to generate token";
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
