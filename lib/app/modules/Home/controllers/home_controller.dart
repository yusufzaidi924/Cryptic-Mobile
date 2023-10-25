import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/ChatList/controllers/chat_list_controller.dart';
import 'package:edmonscan/app/modules/TransferPage/controllers/transfer_page_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final loading = true.obs;

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

  /**
   * Init Home Page
   */
  initData() async {
    loading.value = true;
    update();
    await authCtrl.updateBalance();
    await authCtrl.getTransactionHistory();

    await getRecentSentUser();

    loading.value = false;
    update();
  }

  /**
   * Get Recent Sent Users
   */
  final _recentUsers = Rx<List<UserModel>>([]);
  List<UserModel> get recentUsers => _recentUsers.value;
  getRecentSentUser() async {
    // EasyLoading.show();
    try {
      final data = {
        'uid': authCtrl.authUser!.id,
        'count': 10,
      };

      final res = await UserRepository.getRecentSentUsers(data);
      Logger().i(res);
      if (res['statusCode'] == 200) {
        // EasyLoading.dismiss();
        final resData = res['data'];
        _recentUsers.value = resData
            .map((data) => UserModel.fromJson(data))
            .toList()
            .cast<UserModel>();

        update();
      } else {
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      // EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  /**
   * Go To View Transaction
   */
  onViewTransaction(String tx) async {
    String url = "https://bitcoinexplorer.org/tx/${tx}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: 'Could not launch $url');
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
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
