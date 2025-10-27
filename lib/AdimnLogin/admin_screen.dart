
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gym_admin/AdimnLogin/admin_controller.dart';


// class AdminScreen extends GetView<AdminController> {
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Align(
//         child: Container(
//           width: 140.w,
//           height: 280.h,
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 198, 196, 196),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 20.h),
//                 Text(
//                   "Admin Login",
//                   style: TextStyle(
//                     fontSize: 9.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blueGrey[900],
//                   ),
//                 ),
//                 SizedBox(height: 25.h),

//                 // Email field
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15.w),
//                   child: customTextField(
//                     text: "Enter your email",
//                     icon: Icons.email_outlined, // 👈 এখন এটা suffix এ দেখাবে
//                     controller: controller.usernameController,
//                   ),
//                 ),

//                 SizedBox(height: 15.h),

//                 // Password field with Obx outside
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15.w),
//                   child: Obx(
//                     () => customTextField(
//                       text: "Enter your password",
//                       icon: Icons.lock_outline,
//                       controller: controller.passwordController,
//                       isPassword: true,
//                       obscure: controller.obscurePassword.value,
//                       onToggle: () {
//                         controller.obscurePassword.value =
//                             !controller.obscurePassword.value;
//                       },
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 30.h),

//                 // Login button
//                 Obx(
//                   () => GestureDetector(
//                     onTap: () {
//                       controller.login(
//                         controller.usernameController.text.trim(),
//                         controller.passwordController.text.trim(),
//                       );
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 35.h,
//                       width: 111.w,
//                       decoration: BoxDecoration(
//                         color: controller.isLoading.value
//                             ? Colors.grey
//                             : Colors.blueGrey[700],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: controller.isLoading.value
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             )
//                           : Text(
//                               "Login",
//                               style: TextStyle(
//                                 fontSize: 6.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//  Widget customTextField({
//   required String text,
//   required TextEditingController controller,
//   IconData? icon, // non-password icon
//   bool isPassword = false,
//   bool obscure = false,
//   VoidCallback? onToggle,
// }) {
//   return TextField(
//     controller: controller,
//     obscureText: isPassword ? obscure : false,
//     style: const TextStyle(fontSize: 16, color: Colors.black87),
//     decoration: InputDecoration(
//       labelText: text,
//       hintText: text,
//       // prefixIcon: isPassword ? const Icon(Icons.lock_outline, color: Colors.blueGrey) : null,
//       suffixIcon: isPassword
//           ? IconButton(
//               icon: Icon(
//                 obscure
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 color: Colors.blueGrey,
//               ),
//               onPressed: onToggle,
//             )
//           : (icon != null
//               ? Icon(
//                   icon, // non-password icon as suffix
//                   color: Colors.blueGrey,
//                 )
//               : null),
//       filled: true,
//       fillColor: const Color.fromARGB(255, 240, 240, 240),
//       floatingLabelBehavior: FloatingLabelBehavior.auto,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.grey, width: 1),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
//       ),
//     ),
//   );
// }

// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/AdimnLogin/admin_controller.dart';

class AdminScreen extends GetView<AdminController> {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌌 Modern professional material palette
    final backgroundColor = const Color(0xFFF5F7FA); // light gray background
    final cardColor = Colors.white; // card background
    final labelColor = Colors.blueGrey.shade800; // field labels
    final borderColor = Colors.grey.shade400; // field border
    final focusBorderColor = Colors.tealAccent.shade400; // focus border
    final buttonColor = Colors.tealAccent.shade400; // login button
    final buttonLoadingColor = Colors.grey.shade400; // loading button
    final textColor = Colors.white; // login text

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Align(
        child: Container(
          width: 140.w,
          height: 280.h,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 25.h),

                // Email field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: customTextField(
                    text: "Enter your email",
                    icon: Icons.email_outlined,
                    controller: controller.usernameController,
                    fillColor: Colors.grey.shade100,
                    labelColor: labelColor,
                    borderColor: borderColor,
                    focusedBorderColor: focusBorderColor,
                  ),
                ),

                SizedBox(height: 15.h),

                // Password field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Obx(
                    () => customTextField(
                      text: "Enter your password",
                      icon: Icons.lock_outline,
                      controller: controller.passwordController,
                      isPassword: true,
                      obscure: controller.obscurePassword.value,
                      onToggle: () {
                        controller.obscurePassword.value =
                            !controller.obscurePassword.value;
                      },
                      fillColor: Colors.grey.shade100,
                      labelColor: labelColor,
                      borderColor: borderColor,
                      focusedBorderColor: focusBorderColor,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Login button
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.login(
                        controller.usernameController.text.trim(),
                        controller.passwordController.text.trim(),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35.h,
                      width: 111.w,
                      decoration: BoxDecoration(
                        color: controller.isLoading.value
                            ? buttonLoadingColor
                            : buttonColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.tealAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 6.sp,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField({
    required String text,
    required TextEditingController controller,
    IconData? icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    Color fillColor = Colors.white,
    Color labelColor = Colors.black87,
    Color borderColor = Colors.grey,
    Color focusedBorderColor = Colors.tealAccent,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.blueGrey,
                ),
                onPressed: onToggle,
              )
            : (icon != null
                ? Icon(
                    icon,
                    color: Colors.blueGrey,
                  )
                : null),
        filled: true,
        fillColor: fillColor,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
      ),
    );
  }
}
