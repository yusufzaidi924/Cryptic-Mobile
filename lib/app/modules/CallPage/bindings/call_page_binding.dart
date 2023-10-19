import 'package:get/get.dart';

import '../controllers/call_page_controller.dart';

class CallPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallPageController>(
      () => CallPageController(),
    );
  }
}
