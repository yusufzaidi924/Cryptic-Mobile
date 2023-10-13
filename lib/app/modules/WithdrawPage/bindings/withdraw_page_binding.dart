import 'package:get/get.dart';

import '../controllers/withdraw_page_controller.dart';

class WithdrawPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawPageController>(
      () => WithdrawPageController(),
    );
  }
}
