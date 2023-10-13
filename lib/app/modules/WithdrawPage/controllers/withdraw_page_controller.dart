import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawPageController extends GetxController {
  //TODO: Implement WithdrawPageController

  @override
  void onInit() {
    super.onInit();
  }

  final count = 0.obs;
  final amountController = TextEditingController();

  List<int> priceList = [
    50,
    100,
    200,
    500,
    1000,
    2000,
  ];
  final selectedPriceIndex = Rx<int>(-1);

  /*****************************
   * Update Selected Price Index
   */
  selectPrice(int index) {
    selectedPriceIndex.value = index;
    amountController.text = priceList[index].toString();
    update();
  }

  /*********************************
   * Withdraw 
   */
  withdraw() {
    Get.toNamed(Routes.PAYMENT_RESULT_PAGE);
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
