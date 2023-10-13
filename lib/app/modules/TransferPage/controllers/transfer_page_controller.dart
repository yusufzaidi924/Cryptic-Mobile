import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:get/get.dart';

class TransferPageController extends GetxController {
  //TODO: Implement TransferPageController

  final count = 0.obs;

  /***************************
   * Transfer Balance To User
   */
  onTransfer() {
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
