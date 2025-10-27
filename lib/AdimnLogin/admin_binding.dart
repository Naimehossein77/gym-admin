import 'package:get/get.dart';
import 'package:gym_admin/AdimnLogin/admin_controller.dart';

class AdminBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AdminController());
  }
}