import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyQRController extends GetxController {
  //TODO: Implement MyQRController

  final count = 0.obs;
  final authCtrl = Get.find<AuthController>();

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    CustomSnackBar.showCustomSnackBar(
        title: "SUCCESS", message: "Copied wallet address to clipboard");
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
