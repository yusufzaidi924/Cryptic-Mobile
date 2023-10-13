import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpController extends GetxController {
  //TODO: Implement TopUpController

  final count = 0.obs;
  final amountController = TextEditingController();

  /**********************************
   * Go To My PaymentMethod Page
   */
  goMyPaymentMethod() {
    Get.toNamed(Routes.MY_P_M_PAGE);
  }

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
