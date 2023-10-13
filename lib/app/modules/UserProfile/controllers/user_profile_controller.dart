import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  //TODO: Implement UserProfileController

  final count = 0.obs;

  /***********************
   * Go To Transfer Page
   */
  goToTransferPage() {
    Get.toNamed(Routes.TRANSFER_PAGE);
  }

  /***********************
   * Go To Request Payment Page
   */
  goToRequestPayment() {
    Get.toNamed(Routes.REQUEST_PAYMENT);
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
