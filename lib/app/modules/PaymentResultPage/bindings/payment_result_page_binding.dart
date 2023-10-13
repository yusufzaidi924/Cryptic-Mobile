import 'package:get/get.dart';

import '../controllers/payment_result_page_controller.dart';

class PaymentResultPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentResultPageController>(
      () => PaymentResultPageController(),
    );
  }
}
