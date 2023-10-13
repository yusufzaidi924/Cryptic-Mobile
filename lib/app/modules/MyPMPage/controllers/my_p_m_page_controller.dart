import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:get/get.dart';

class MyPMPageController extends GetxController {
  //TODO: Implement MyPMPageController

  final count = 0.obs;

  /*****************************
   * Go Topup Page
   */
  goTopUp() {
    Get.back();
  }

  /*******************
   * Go To Add New Card Page
   */
  goAddNewCard() {
    Get.toNamed(Routes.ADD_NEW_CARD);
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
