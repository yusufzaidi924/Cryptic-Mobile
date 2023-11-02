import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';

class AffiliatePageController extends GetxController {
  //TODO: Implement AffiliatePageController
  final authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  String countryCode = "US";
  final phoneNumber = "".obs;
  final isValidPhoneNumber = false.obs;

  final _refUsers = Rx<List<UserModel>>([]);
  List<UserModel> get refUsers => _refUsers.value;

  /*********************
   * Update Phone Number
   */
  void updatePhoneNumber(PhoneNumber? number) {
    phoneNumber.value = number?.completeNumber ?? "";
    validatePhoneNumber(number);
    update();
  }

  /***********************
   * Validate Phone Number
   */
  String? validatePhoneNumber(PhoneNumber? number) {
    try {
      if (number != null) {
        isValidPhoneNumber.value = number.isValidNumber();
      } else {
        isValidPhoneNumber.value = false;
      }
    } catch (e) {
      isValidPhoneNumber.value = false;
    }

    update();
    return isValidPhoneNumber.value ? null : "Invalid Mobile Number";
  }

  /*******************
   * Get Users
   */
  getInitData() async {
    if (authCtrl.authUser!.referral_code == null ||
        authCtrl.authUser!.referral_code == '') {
      await createRefCode();
    }

    try {
      EasyLoading.show();
      final users = await authCtrl.getUsers();
      users.removeWhere((user) => (user.id == authCtrl.authUser!.id));

      _refUsers.value = users
          .where((user) =>
              user.received_ref_code == authCtrl.authUser!.referral_code)
          .toList();
      EasyLoading.dismiss();

      update();
    } catch (e) {
      EasyLoading.dismiss();

      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  /*******************
   * Create Ref Code
   */
  createRefCode() async {
    try {
      EasyLoading.show();
      String code = generateReferralCode();
      final data = {
        "received_ref_code": code,
      };

      final res = await UserRepository.updateUser(authCtrl.authUser!.id, data);

      Logger().i(res);
      if (res['statusCode'] == 200) {
        EasyLoading.dismiss();
        UserModel newUser = authCtrl.authUser!;
        newUser.referral_code = code;
        authCtrl.updateAuthUser(newUser);

        // CustomSnackBar.showCustomSnackBar(
        //     title: "SUCCESS", message: "History Deleted successfully!");
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

  /**************
   * Delete Ref History
   */
  onDeleteHistory(UserModel user) async {
    try {
      EasyLoading.show();
      final data = {
        "received_ref_code": '',
      };

      final res = await UserRepository.updateUser(user.id, data);

      Logger().i(res);
      if (res['statusCode'] == 200) {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: "History Deleted successfully!");
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

  String generateReferralCode() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    String result = '';
    Random random = Random();
    for (int i = 0; i < 6; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  /***************
   * Copy Link
   */
  onCopyLink() {
    try {
      FlutterClipboard.copy(authCtrl.authUser!.referral_code ?? "");
      CustomSnackBar.showCustomSnackBar(
          title: "THANKS", message: "Referral code is copied into clipboard!");
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  /********************
   * Send Referral Code
   */
  onSendRefCode() async {
    if (isValidPhoneNumber.value) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        EasyLoading.show();

        final data = {
          "phone": phoneNumber.value,
          'code': authCtrl.authUser!.referral_code ?? "",
          'fromName':
              "${authCtrl.authUser!.firstName} ${authCtrl.authUser!.firstName}",
          'fromPhone': "${authCtrl.authUser!.phone}"
        };

        final res = await UserRepository.sendReferralCode(data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "Sent referral code successfully!");
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
    } else {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: "Please enter valid phone number!");
    }
  }

  @override
  void onInit() {
    super.onInit();

    getInitData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
