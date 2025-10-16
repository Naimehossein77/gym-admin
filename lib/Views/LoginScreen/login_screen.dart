import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/LoginScreen/login_Screen_controller.dart';

class LoginScreen extends GetView<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Form( 
          key: controller.formKey, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 500,
                decoration: const BoxDecoration(color: Colors.white70),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    Text(
                      "Admin Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50.h),

                    
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
                        suffixIcon: controller.obscurePassword.value
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

                    // 🔘 Continue Button
                    GestureDetector(
                      onTap: () => controller.login(), 
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Color.fromARGB(255, 127, 191, 228),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.sp),
                          child: Align(
                            child: Text(
                              "Continue",
                              style: TextStyle(fontSize: 3.5.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[700]) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: Colors.grey[700]),
                    onPressed: onSuffixTap,
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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