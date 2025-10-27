import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/AdimnLogin/admin_binding.dart';
import 'package:gym_admin/AdimnLogin/admin_screen.dart';
import 'package:gym_admin/Dashboard_Screen/dashboard_binding.dart';
import 'package:gym_admin/Dashboard_Screen/dashboard_screen.dart';
import 'package:gym_admin/Utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configLoading();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: GetMaterialApp(
            title: '',
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'roboto'),
            // home: SplashScreen(),
            initialRoute: Routes.admin,

            // home: HomePage(),
            getPages: [
              GetPage(
                name: Routes.admin,
                page: () =>AdminScreen (),
                binding: AdminBinding(),
              ),
                GetPage(
                name: Routes.dashboard,
                page: () =>DashboardScreen (),
                binding: DashboardBinding(),
              ),
             
             
            ],
          ),
        );
      },
    );
  }
}
