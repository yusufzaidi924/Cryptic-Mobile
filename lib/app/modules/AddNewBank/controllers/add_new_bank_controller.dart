import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AddNewBankController extends GetxController {
  //TODO: Implement AddNewBankController
  final authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final accNumberCtrl = TextEditingController();
  final confirmAccNumberCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();

  final isValidAccNum = false.obs;
  final isValidConfirmAccNum = false.obs;
  final isValidBankName = false.obs;
  final isValidRoutingNum = false.obs;

  /******************************
   * Validate Account Number
   */
  String? validateAccountNumber(String? value) {
    String? res = null;
    isValidAccNum.value = false;
    // Regular expression pattern for a valid bank account number
    final pattern = r'^[0-9]{6,}$';

    // Create a RegExp object with the pattern
    final regex = RegExp(pattern);

    // Perform the validation

    if (value != null) {
      if (value.isEmpty) {
        isValidAccNum.value = false;
        res = 'Account Number is required.';
      } else if (regex.hasMatch(value)) {
        isValidAccNum.value = true;
        res = null;
      } else {
        isValidAccNum.value = false;
        res = "Invalid account number";
      }
    } else {
      isValidAccNum.value = false;
      res = "Please enter card number";
    }
    update();
    return res;
  }

  /*********************************
   * Validate Confirm Account Number
   */
  String? validateConfirmAccNumber(String? value) {
    String? res = null;
    isValidConfirmAccNum.value = false;
    // Regular expression pattern for a valid bank account number
    final pattern = r'^[0-9]{6,}$';

    // Create a RegExp object with the pattern
    final regex = RegExp(pattern);

    // Perform the validation

    if (value != null) {
      if (value.isEmpty) {
        isValidConfirmAccNum.value = false;
        res = 'Account Number is required.';
      } else if (value != accNumberCtrl.text) {
        isValidConfirmAccNum.value = false;
        res = "Account number doesn't match!";
      } else if (regex.hasMatch(value)) {
        isValidConfirmAccNum.value = true;
        res = null;
      } else {
        isValidConfirmAccNum.value = false;
        res = "Invalid account number";
      }
    } else {
      isValidConfirmAccNum.value = false;
      res = "Please enter card number";
    }
    update();
    return res;
  }

  /****************************
   * Validate Bank Name
   */
  String? validateBankName(String? value) {
    String? res = null;
    isValidBankName.value = false;
    if (value != null) {
      if (value.length > 100) {
        isValidBankName.value = false;
        res = 'Invalid bank name';
      } else if (value.isEmpty) {
        isValidBankName.value = false;
        res = 'Bank name is required.';
      } else {
        isValidBankName.value = true;
        res = null;
      }
    } else {
      isValidBankName.value = false;
      res = "Please enter bank name";
    }
    update();
    return res;
  }

  /****************************
   * Validate Bank Name
   */
  String? validateRoutingNumber(String? value) {
    String? res = null;
    isValidRoutingNum.value = false;
    if (value != null) {
      if (value.length > 100) {
        isValidRoutingNum.value = false;
        res = 'Invalid routing number';
      } else if (value.isEmpty) {
        isValidRoutingNum.value = false;
        res = 'Routing number is required.';
      } else {
        isValidRoutingNum.value = true;
        res = null;
      }
    } else {
      isValidRoutingNum.value = false;
      res = "Please enter routing number";
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

        final data = {
          "userId": authCtrl.authUser!.id,
          "account_number": accNumberCtrl.text..trim(),
          'bank_name': bankNameCtrl.text.trim(),
          'routing_number': routingNumberCtrl.text.trim(),
        };

        Logger().d(data);

        final res = await UserRepository.addNewBank(data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "Bank is added successfully!");

          // formKey.currentState!.reset();
          // REST FORM
          accNumberCtrl.text = "";
          confirmAccNumberCtrl.text = "";
          routingNumberCtrl.text = "";
          bankNameCtrl.text = "";

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
