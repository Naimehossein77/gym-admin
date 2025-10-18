
import 'package:get/get.dart';
import 'package:gym_admin/Views/AdminLoginScreen/login_Screen_controller.dart';

class AdminLoginScreenBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>AdminLoginScreenController());
  }

}