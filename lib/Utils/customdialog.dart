import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

void showAddMemberDialog(BuildContext context, DashboardScreenController c) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 16.h),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 230, 227, 227),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row: Title + Close
                Row(
                  children: [
                    Text(
                      'Add Member',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.black, size: 6.sp),
                      splashRadius: 14.r,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Name
                _DarkField(
                  controller: c.nameC,
                  hint: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 8.h),

                // Email
                _DarkField(
                  controller: c.emailC,
                  hint: 'Email',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 8.h),

                // Phone
                _DarkField(
                  controller: c.phoneC,
                  hint: 'Phone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 8.h),

                // Membership Type (Dropdown)
                Obx(
                  () => _DarkDropdown<String>(
                    value: c.selectedMembership.value,
                    items:
                        c.membershipTypes
                            .map(
                              (t) => DropdownMenuItem<String>(
                                value: t,
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 4.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: c.changeMembership,
                    label: 'Membership Type',
                  ),
                ),
                SizedBox(height: 12.h),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: c.onContinueAddMember,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 4.sp,
                        fontWeight: FontWeight.w600,
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

/// ---------- Reusable dark TextField ----------
class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  const _DarkField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black, fontSize: 4.sp),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 5.sp, color: Colors.black),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black, fontSize: 4.sp),
        filled: true,
        fillColor: Colors.white, // গাঢ় ধূসর ফিল
        contentPadding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 8.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

/// ---------- Reusable dark Dropdown ----------
class _DarkDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String label;
  const _DarkDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: const Color.fromARGB(255, 230, 227, 227),
      iconEnabledColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontSize: 3.8.sp),
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 227, 227),
        contentPadding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 8.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      style: TextStyle(color: Colors.black, fontSize: 4.sp),
    );
  }
}
