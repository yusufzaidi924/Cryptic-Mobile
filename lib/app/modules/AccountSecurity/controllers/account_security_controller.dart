import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AccountSecurityController extends GetxController {
  //TODO: Implement AccountSecurityController
  final authCtrl = Get.find<AuthController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final deleteTextCtrl = TextEditingController();

  /************************
   * Validate Password 
   */
  String? validatePass(String? value) {
    String? res = null;
    if (value != null) {
      if (value.length < 8) {
        res = 'Password should be at least 8 characters';
      } else if (value.length > 30) {
        res = 'Password should be less than 30 characters';
      } else if (value.isEmpty) {
        res = 'Password is required.';
      } else {
        res = null;
      }
    } else {
      res = "Please enter password";
    }
    update();
    return res;
  }

  String? validateConfirmPass(String? value) {
    String? res = null;
    if (value != null) {
      if (value.length < 8) {
        res = 'Password should be at least 8 characters';
      } else if (value.length > 30) {
        res = 'Password should be less than 30 characters';
      } else if (value.isEmpty) {
        res = 'Password is required.';
      } else if (value != newPassCtrl.text) {
        res = "Password doesn't match";
      } else {
        res = null;
      }
    } else {
      res = "Please enter password";
    }
    update();
    return res;
  }

  /*********************
   * Update Phone Number
   */
  validateDeleteText(String? value) {
    if (value == null || value == "") {
      return 'Please type "DELETE ACCOUNT"';
    } else if (value != "DELETE ACCOUNT") {
      return 'Please type "DELETE ACCOUNT"';
    }
    return null;
  }

  /*******************************
   * Update Password
   */
  onUpdatePassword() async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        EasyLoading.show();

        final data = {
          'uid': authCtrl.authUser!.id,
          'oldPass': oldPassCtrl.text,
          'newPass': newPassCtrl.text,
        };

        final res = await UserRepository.updatePassword(data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "Password is updated successfully!");
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

  /**
   * DELETE ACCOUNT
   */
  onDeleteAccount() async {
    if (deleteFormKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        EasyLoading.show();

        int uid = authCtrl.authUser!.id;
        final data = {
          'status': AuthUserStatus.DELETED,
        };
        final res = await UserRepository.deleteAccount(uid, data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "Deleted account successfully!");
          await authCtrl.logout();
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
