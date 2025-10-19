import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  DashboardScreenController controller = Get.put(DashboardScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100.h),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDuplicateLoginDialog();
                    },
                    child: Text("Add Member"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                  width: 80.w,
                  child: customTextField(
                    context,
                    label: "Name",
                    hintText: "name",
                    controller: controller.textController,
                  ),
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 80.w,
                  child: customTextField(
                    context,
                    label: "Email",
                    hintText: "email",
                    controller: controller.textController,
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
                          controller: controller.textController,
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
                  onTap: () {
                  
                    // Get.toNamed(Routes.dashbordScreen);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
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
                      child: Text(
                        "Add member",
                        style: TextStyle(fontSize: 3.5.sp, color: Colors.black),
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
}
