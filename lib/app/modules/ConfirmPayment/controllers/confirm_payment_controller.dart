import 'dart:async';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ConfirmPaymentController extends GetxController {
  //TODO: Implement ConfirmPaymentController
  final authCtrl = Get.find<AuthController>();

  final isAvailable = false.obs;

  /***************************
   * Resend OTP Code
   */
  sendOtpCode({bool isShowLoading = true, bool isShowNotify = true}) async {
    try {
      if (isShowLoading) EasyLoading.show();
      String phone = authCtrl.authUser!.phone;
      final res = await UserRepository.resendOtpCode({'phone': phone});
      Logger().i(res);
      if (res['statusCode'] == 200) {
        if (isShowLoading) EasyLoading.dismiss();
        _estimateTime.value = 180;
        if (isShowNotify)
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: res['message']);

        startTimer();
      } else {
        if (isShowLoading) EasyLoading.dismiss();

        if (isShowNotify)
          CustomSnackBar.showCustomErrorSnackBar(
              title: "ERROR",
              message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      if (isShowLoading) EasyLoading.dismiss();

      Logger().e(e.toString());
      if (isShowNotify)
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  final _estimateTime = Rx<int>(180);
  int get estimateTime => _estimateTime.value;

  Timer? _timer;
  // Start the timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _estimateTime.value--;
      update(); // Update the UI
      if (estimateTime < 0) {
        stopTimer();
        sendOtpCode();
        // CustomSnackBar.showCustomErrorSnackBar(
        //     title: "Timeout", message: "Last code is expired!");
      }
    });
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
    _estimateTime.value = 0;
    update(); // Update the UI
  }

  final verifyCode = ''.obs;
  setVerifyCode(String code) {
    verifyCode.value = code;
    update();
  }

  final terms1 = false.obs;
  final terms2 = false.obs;
  updateTerms1(bool? value) {
    if (value == null) return;
    terms1.value = value;
  }

  updateTerms2(bool? value) {
    if (value == null) return;
    terms2.value = value;
  }

  confirmCode() async {
    if (!terms1.value || !terms2.value) {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ALERT", message: "Please accept terms and conditions first!");
      return;
    }
    if (verifyCode == '') return;

    try {
      EasyLoading.show();
      String code = verifyCode.value;
      String phone = authCtrl.authUser!.phone;
      final res =
          await UserRepository.verifyCode({'otp': code, 'phone': phone});
      Logger().i(res);
      if (res['statusCode'] == 200) {
        Get.back(result: true);
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  @override
  void onInit() {
    super.onInit();

    sendOtpCode();
    // startTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
