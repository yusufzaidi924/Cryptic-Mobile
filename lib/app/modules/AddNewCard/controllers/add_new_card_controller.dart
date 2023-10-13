import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewCardController extends GetxController {
  //TODO: Implement AddNewCardController

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
      if (value.length > 16) {
        isValidNumber.value = false;
        res = 'Card Number should be less than 16 characters';
      } else if (value.isEmpty) {
        isValidNumber.value = false;
        res = 'Card Number is required.';
      } else {
        isValidNumber.value = true;
        res = null;
      }
    } else {
      isValidNumber.value = false;
      res = "Please enter First Name";
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
      if (value.length > 16) {
        isValidExpDate.value = false;
        res = 'Card Number should be less than 16 characters';
      } else if (value.isEmpty) {
        isValidExpDate.value = false;
        res = 'Card Number is required.';
      } else {
        isValidExpDate.value = true;
        res = null;
      }
    } else {
      isValidExpDate.value = false;
      res = "Please enter First Name";
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
      if (value.length > 16) {
        isValidCvv.value = false;
        res = 'Card Number should be less than 16 characters';
      } else if (value.isEmpty) {
        isValidCvv.value = false;
        res = 'Card Number is required.';
      } else {
        isValidCvv.value = true;
        res = null;
      }
    } else {
      isValidCvv.value = false;
      res = "Please enter First Name";
    }
    update();
    return res;
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
