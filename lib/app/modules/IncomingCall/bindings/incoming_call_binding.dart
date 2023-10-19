import 'package:get/get.dart';

import '../controllers/incoming_call_controller.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(),
    );
  }
}
