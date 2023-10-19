import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/local_storage.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final count = 0.obs;
  final currentIndex = 0.obs;

  init() async {
    Logger().i("Initialization");
    PermissionStatus cameraStatus = await checkCameraPermission();
    PermissionStatus galleryStatus = await checkCameraPermission();
  }

  @override
  void onInit() {
    super.onInit();

    storeDataToLocal(
        key: AppLocalKeys.WELCOME_PASS,
        value: true,
        type: StorableDataType.BOOL);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onPageChanged(index) {
    currentIndex.value = index;
    update();
  }
}
