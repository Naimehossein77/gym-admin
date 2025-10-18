import 'package:get/get.dart';
import 'package:gym_admin/Views/Nember%20Login/nember_login_controller.dart';

class NemberLoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>NemberLoginController());
  }

}