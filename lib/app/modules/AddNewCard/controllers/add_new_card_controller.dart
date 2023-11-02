import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/AddNewBank/controllers/add_new_bank_controller.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AddNewCardController extends GetxController {
  //TODO: Implement AddNewCardController
  final authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();

  final isValidNumber = false.obs;
  final isValidExpDate = false.obs;
  final isValidCvv = false.obs;

  /******************************
   * Validate Card Number
   */
  /****************************
   * Validate Detail First Name
   */
  String? validateCardNumber(String? value) {
    String? res = null;
    isValidNumber.value = false;
    if (value != null) {
      if (value.length > 22 || value.length < 22) {
        isValidNumber.value = false;
        res = 'Invalid Card Number';
      } else if (value.isEmpty) {
        isValidNumber.value = false;
        res = 'Card Number is required.';
      } else {
        isValidNumber.value = true;
        res = null;
      }
    } else {
      isValidNumber.value = false;
      res = "Please enter card number";
    }
    update();
    return res;
  }

  /****************************
   * Validate Expire Date
   */
  String? validateExpDate(String? value) {
    String? res = null;
    isValidExpDate.value = false;
    if (value != null) {
      if (value.length > 5 || value.length < 5) {
        isValidExpDate.value = false;
        res = 'Invalid expire date format';
      } else if (value.isEmpty) {
        isValidExpDate.value = false;
        res = 'Expire Date is required!';
      } else {
        isValidExpDate.value = true;
        res = null;
      }
    } else {
      isValidExpDate.value = false;
      res = "Please enter expire date";
    }
    update();
    return res;
  }

  /****************************
   * Validate Card CVV
   */
  String? validateCardCVV(String? value) {
    String? res = null;
    isValidCvv.value = false;
    if (value != null) {
      if (value.length > 4 || value.length < 3) {
        isValidCvv.value = false;
        res = 'Invalid xvv';
      } else if (value.isEmpty) {
        isValidCvv.value = false;
        res = 'cvv is required.';
      } else {
        isValidCvv.value = true;
        res = null;
      }
    } else {
      isValidCvv.value = false;
      res = "Please enter cvv";
    }
    update();
    return res;
  }

  /********************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.11.1
   * @Desc: Save Card
   */
  onSaveCard() async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        EasyLoading.show();

        String expireDate = expDateController.text;
        final expArr = expireDate.split("/");

        final data = {
          "userId": authCtrl.authUser!.id,
          "card_number": cardNumberController.text.replaceAll(' ', '').trim(),
          'expire_month': int.parse(expArr[0]),
          'expire_year': int.parse(expArr[1]),
          'cvv': int.parse(cvvController.text.trim()),
        };

        Logger().d(data);

        final res = await UserRepository.addNewCard(data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "Card is added successfully!");

          // formKey.currentState!.reset();
          // REST FORM
          cardNumberController.text = "";
          expDateController.text = "";
          cvvController.text = "";

          update();
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
  }

  onAddBank() {
    Get.delete<AddNewBankController>();

    Get.toNamed(Routes.ADD_NEW_BANK);
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
}
