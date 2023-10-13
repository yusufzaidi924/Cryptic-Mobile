import 'package:get/get.dart';

import '../controllers/request_payment_controller.dart';

class RequestPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestPaymentController>(
      () => RequestPaymentController(),
    );
  }
}
