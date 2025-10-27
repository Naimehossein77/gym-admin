import 'package:get/get.dart';
import 'package:gym_admin/Dashboard_Screen/dashboard_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(DashboardController());
  }
}