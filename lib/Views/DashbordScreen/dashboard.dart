import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

class MemberListView extends StatelessWidget {
  final DashboardScreenController controller = Get.put(
    DashboardScreenController(),
  );

  MemberListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.members.isEmpty) {
        return const Center(child: Text('No members found.'));
      }

      const List<String> headers = [
        'ID',
        'Name',
        'Email',
        'Phone',
        'Type',
        'Status',
        'Delete Member',
        'Add Credential',
        'Token Generate',
        'User Name',
        'View Token',
      ];

      return Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDuplicateLoginDialog();
                },
                child: Text("Add Member"),
              ),
              // SizedBox(width: 20),
              // customTextField(
              //   context,
              //   label: "search",
              //   hintText: "search",
              //   controller: controller.searchController,
              // ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(top: 16),
              color: Colors.blueAccent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  children:
                      headers.map((header) {
                        return Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: controller.paginatedMembers.length,
              itemBuilder: (context, index) {
                final member = controller.paginatedMembers[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          // ID
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(member.id.toString()),
                          ),
                          // Name
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(member.name),
                          ),
                          // Email
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(member.email),
                          ),
                          // Phone
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(member.phone),
                          ),
                          // Type
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(member.membershipType),
                          ),
                          // Status
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    member.status.toLowerCase() == 'active'
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                member.status,
                                style: TextStyle(
                                  color:
                                      member.status.toLowerCase() == 'active'
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // Delete Member
                          Container(
                            width: 150,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Delete Member',
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Confirm Delete",
                                  middleText:
                                      "Are you sure you want to delete ${member.name}?",
                                  textCancel: "Cancel",
                                  textConfirm: "Delete",
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    Get.back();
                                    controller.deleteMember(member.id);
                                  },
                                );
                              },
                            ),
                          ),
                          // Add Credential
                          Container(
                            width: 150,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Add Credential',
                              onPressed: () {
                                credendentials();
                              },
                            ),
                          ),
                          // Token Generate
                          Container(
                            width: 150,
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                controller.tokenGenarate();
                              },
                              child: Container(
                                height: 25.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Center(child: Text("Generate")),
                              ),
                            ),
                          ),
                          // User Name
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: const Text("userName"),
                          ),
                          // View Token
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: const Text(
                              "toksdfjsfusdfgjsfddujfgdsjfgjsdfgfen",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Pagination Controls
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                      controller.currentPage.value > 0
                          ? controller.previousPage
                          : null,
                ),
                Text(
                  'Page ${controller.currentPage.value + 1} of ${((controller.members.length - 1) / controller.pageSize).ceil()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed:
                      ((controller.currentPage.value + 1) *
                                  controller.pageSize <
                              controller.members.length)
                          ? controller.nextPage
                          : null,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void showDuplicateLoginDialog() {
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: "Duplicate Login",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: const Alignment(0, -0.5),
          child: Container(
            width: Get.width * 0.50,
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "ADD MEMBER",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  width: 70.w,
                  child: customTextField(
                    context,
                    label: "Name",
                    hintText: "name",
                    controller: controller.nameController,
                  ),
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 70.w,
                  child: customTextField(
                    context,
                    label: "Email",
                    hintText: "email",
                    controller: controller.emailController,
                  ),
                ),
                SizedBox(height: 10.h),
                // Text("Phone number"),
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        controller.selectedCountryCode =
                            '+${country.phoneCode}';
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.selectedCountryCode,
                                style: TextStyle(
                                  fontSize: 3.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // SizedBox(width: 20.w),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 60.w,
                        child: customTextField(
                          context,
                          label: "",
                          hintText: "phone number",
                          controller: controller.phoneController,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 80.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    // horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedPlan.value,
                        isExpanded: true,
                        items:
                            controller.plans
                                .map(
                                  (plan) => DropdownMenuItem(
                                    value: plan,
                                    child: Text(plan),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          controller.selectedPlan.value = value!;
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () async {
                    await controller.addMember();
                    if (controller.responseMessage.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(controller.responseMessage.value),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 110.w),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Color.fromARGB(255, 127, 191, 228),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          "Add member",
                          style: TextStyle(
                            fontSize: 3.5.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Widget customTextField(
    BuildContext context, {
    required String label,
    required String hintText,
    required TextEditingController controller,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon:
                prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.grey[700])
                    : null,
            suffixIcon:
                suffixIcon != null
                    ? IconButton(
                      icon: Icon(suffixIcon, color: Colors.grey[700]),
                      onPressed: onSuffixTap,
                    )
                    : null,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 7,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void credendentials() {
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: "Duplicate Login",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: const Alignment(0, -0.5),
          child: Container(
            width: Get.width * 0.50,

            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "ADD CREDENTIAL",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  width: 80.w,
                  child: customTextField(
                    context,
                    label: "userName",
                    hintText: "userName",
                    controller: controller.userNameController,
                  ),
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 80.w,
                  child: customTextField(
                    context,
                    label: "Password",
                    hintText: "password",
                    controller: controller.passwordController,
                  ),
                ),

                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () async {
                    // controller.selectedMember.value = member;
                    // controller.credendentials();
                    controller.setPassword(
                      username: "@limon",
                      password: "limon123",
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 110.w),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Color.fromARGB(255, 127, 191, 228),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          "set password",
                          style: TextStyle(
                            fontSize: 3.5.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
