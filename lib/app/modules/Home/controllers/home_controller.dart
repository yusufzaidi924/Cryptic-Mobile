import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/ChatList/controllers/chat_list_controller.dart';
import 'package:edmonscan/app/modules/TransferPage/controllers/transfer_page_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  final authCtrl = Get.find<AuthController>();

  final selectedInex = 0.obs;
  final PageController pageController = PageController();

  void onPageChanged(index) {
    // final subscribeCtl = Get.find<SubscriptionController>();
    // if (index > 0) {
    //   if (subscribeCtl.subscribeStatus == SubscribeStatus.FOR_TRIAL ||
    //       subscribeCtl.subscribeStatus == SubscribeStatus.EXPIRED ||
    //       subscribeCtl.subscribeStatus == SubscribeStatus.CANCELED) {
    //     updateBottombarIndex(0);
    //     Get.toNamed(Routes.SUBSCRIPTION);
    //     return;
    //   }
    // }
    selectedInex.value = index;
    update();
  }

  updateBottombarIndex(index) {
    // final subscribeCtl = Get.find<SubscriptionController>();
    // if (index > 0) {
    //   if (subscribeCtl.subscribeStatus == SubscribeStatus.FOR_TRIAL ||
    //       subscribeCtl.subscribeStatus == SubscribeStatus.EXPIRED) {
    //     Get.toNamed(Routes.SUBSCRIPTION);
    //     return;
    //   }
    // }
    // pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeIn,
    // );
    if (index == 1) {
      Get.delete<TransferPageController>();
      Get.toNamed(Routes.TRANSFER_PAGE);
    }
    if (index == 2) {
      Get.toNamed(Routes.WITHDRAW_PAGE);
    }

    if (index == 3) {
      Get.delete<ChatListController>();
      Get.toNamed(Routes.CHAT_LIST);
    }
    if (index == 4) {
      Get.toNamed(Routes.MY_PROFILE);
    }
    // selectedInex.value = index;
    // setTitle(_titleList[index]);
    update();
  }

  // setTitle(String _title) {
  //   title.value = _title;
  //   update();
  // }

  /*****************************
   * Go Topup Page
   */
  goTopUp() {
    Get.toNamed(Routes.TOP_UP);
  }

  /*************************
   * Go To User Profile Page
   */
  goToProfilePage() {
    Get.toNamed(Routes.USER_PROFILE);
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
