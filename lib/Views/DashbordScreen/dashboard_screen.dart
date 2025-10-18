import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

class DashboardScreen extends GetView<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Align(
            child: Container(
              height: 650,
              width: 1000,

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                // boxShadow: [BoxShadow()],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.r,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "Dashboard Screen",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 7.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    customContainer(text: "total nember"),
                    SizedBox(height: 20.h),
                    customContainer(text: "Active token "),
                    SizedBox(height: 20.h),
                    customContainer(text: "NFC connected"),
                    SizedBox(height: 20.h),
                    customContainer(text: "Add nember"),
                    SizedBox(height: 20.h),
                    customContainer(text: "Setting"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customContainer({required String text}) {
    return Container(
      height: 40.h,
      width: 80.w,

      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Align(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 3.5.sp,
          ),
        ),
      ),
    );
  }
}
