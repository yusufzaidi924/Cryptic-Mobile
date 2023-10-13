import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:get/get.dart';

class RequestPaymentController extends GetxController {
  //TODO: Implement RequestPaymentController

  final count = 0.obs;

  /****************************
   * Request Payment Function
   */
  onRequestPayment() {
    Get.toNamed(Routes.CONFIRM_PAYMENT);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
