import 'package:get/get.dart';

import '../controllers/my_q_r_controller.dart';

class MyQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyQRController>(
      () => MyQRController(),
    );
  }
}
