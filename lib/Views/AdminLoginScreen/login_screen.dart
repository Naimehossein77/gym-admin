import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/AdminLoginScreen/login_Screen_controller.dart';

class AdminLoginScreen extends GetView<AdminLoginScreenController> {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 227, 227),
        title: Text(
          "Gym Admin Panel",
          style: TextStyle(
            color: Colors.black,
            fontSize: 5.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Align(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 600,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  // boxShadow: [BoxShadow()],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.sp,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      customTextField(
                        context,
                        label: "Username",
                        hintText: "username",
                        prefixIcon: Icons.person,
                        controller: controller.userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "userName cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // 🧩 Password Field
                      Obx(
                        () => customTextField(
                          context,
                          label: "Password",
                          hintText: "password",
                          prefixIcon: Icons.lock_outline,
                          controller: controller.passwordController,
                          isPassword: controller.obscurePassword.value,
                          suffixIcon:
                              controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                          onSuffixTap: controller.togglePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: () {
                          controller.adminUserLogin();
                          // Get.toNamed(Routes.dashbordScreen);
                        },
                        child: Container(
                          height: 50,
                          width: 450,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 3.sp,
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
            ],
          ),
        ),
      ),
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
          style: TextStyle(
            fontSize: 3.sp,
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
            hintStyle: TextStyle(color: Colors.grey, fontSize: 3.sp),
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
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
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
