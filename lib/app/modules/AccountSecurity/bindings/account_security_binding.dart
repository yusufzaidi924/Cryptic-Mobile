import 'package:get/get.dart';

import '../controllers/account_security_controller.dart';

class AccountSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSecurityController>(
      () => AccountSecurityController(),
    );
  }
}
