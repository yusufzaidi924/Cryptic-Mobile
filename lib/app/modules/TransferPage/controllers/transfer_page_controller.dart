import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/ConfirmPayment/controllers/confirm_payment_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class TransferPageController extends GetxController {
  //TODO: Implement TransferPageController

  final authCtrl = Get.find<AuthController>();

  final _selectedUser = Rxn<UserModel>();
  UserModel? get selectedUser => _selectedUser.value;
  updateSelectedUser(UserModel user) {
    _selectedUser.value = user;
    update();
  }

  final _users = Rx<List<UserModel>>([]);
  List<UserModel> get users => _users.value;
  /***************************
   * Transfer Balance To User
   */
  onTransfer() async {
    if (formKey.currentState!.validate()) {
      if (selectedUser == null) {
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ALERT",
            message: "Please select user to transfer crypto currency");
        return;
      } else if (selectedUser?.btcAddress == null) {
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ALERT", message: "This user doesn't have BTC wallet yet.");
        return;
      }
      Get.delete<ConfirmPaymentController>();
      final res = await Get.toNamed(Routes.CONFIRM_PAYMENT);

      Logger().d(res);
      if (res == null) return;
      if (res == true) {
        try {
          EasyLoading.show();
          // String address = 'mxvH4v7XdWXM61WnJMtXAyoeavp12SGn4p';
          String address = selectedUser!.btcAddress!;
          final amount = double.parse(amountCtrl.text);
          int satAmount = (amount * CryptoConf.BITCOIN_DIGIT).toInt();
          Logger().d('SATOSHI : $satAmount');
          await authCtrl.btcService!.sendTx(address, satAmount);
          EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.dismiss();
          print(e.toString());
          Logger().e(e);
          CustomSnackBar.showCustomErrorSnackBar(
              title: "ERROR", message: e.toString());
        }
      }
    }
    // Get.toNamed(Routes.CONFIRM_PAYMENT);
  }

  /******************************
   * @Auth: geniusdev0813
   * @Date: 2023.10.24
   * @Desc: Save Transaction
   */
  saveTransaction() {}

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  validateAmount(String? value) {
    if (value == null || value == '') {
      return "Please enter amount";
    } else {
      double? amount = double.tryParse(value);
      if (amount == null) {
        return "Invalid number format!";
      } else if (amount < CryptoConf.BITCOIN_MIN_AMOUNT) {
        return "Minium amount is ${CryptoConf.BITCOIN_MIN_AMOUNT}BTC";
      } else if ((authCtrl.btcService != null) &&
          (amount > authCtrl.btcService!.balance)) {
        return "Insufficient Balance";
      }
    }
    return null;
  }

  validateMessage(String? value) {
    if (value == null || value == '') {
      return "Please enter message";
    } else if (value.length > 120) {
      return "Message should be less than 120 characters";
    }
    return null;
  }

  final loading = true.obs;
  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments;
    if (params != null) {
      _selectedUser.value = params['user'];
    }

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

  initData() async {
    try {
      // loading.value = true;
      // update();
      EasyLoading.show();
      final userList = await authCtrl.getUsers();
      userList
          .removeWhere((userModel) => userModel.id == authCtrl.authUser!.id);
      _users.value = userList;
      if (selectedUser == null && users.isNotEmpty) {
        _selectedUser.value = users[0];
      }
      // loading.value = false;
      EasyLoading.dismiss();
      update();
    } catch (e) {
      // loading.value = false;
      EasyLoading.dismiss();
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
        title: "ERROR",
        message: e.toString(),
      );
    }
  }
}
