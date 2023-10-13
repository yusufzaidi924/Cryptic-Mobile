import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/ProjectsPage/views/projects_page_view.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final count = 0.obs;
  final currentIndex = 0.obs;
  final PageController pageController = PageController();
  List<String> titles = [
    "Allow Your Camera",
    "Allow Your Photos",
    "Welcome to back",
  ];

  List<String> subTitles = [
    "This app needs access to your camera to take photo of PDF documents. If you don't feel comfortable with this permission, you can go to settings and modify it at anytime.",
    "This app needs to access your photo gallery to upload images of documents. If you don't feel comfortable with this permission, you can go to settings and modify it at anytime.",
    'Camera and photo gallery permission are already granted. Please click "Next" button to continue',
  ];

  init() async {
    Logger().i("Initialization");
    PermissionStatus cameraStatus = await checkCameraPermission();
    PermissionStatus galleryStatus = await checkCameraPermission();
    Logger().i(galleryStatus);
    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      Logger().i("Granted All");
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );

      currentIndex.value = 2;
      // update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    //  init();
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

  void nextEvent(int length) async {
    switch (currentIndex.value) {
      case 0:
        PermissionStatusEnum status = await requestCameraPermission();
        if (status != PermissionStatusEnum.GRANTED) {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Failed!', message: 'Faild to grant camera permission');
        }

        break;
      case 1:
        PermissionStatusEnum status = await requestGalleryPermission();
        if (status != PermissionStatusEnum.GRANTED) {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Failed!',
              message: 'Faild to grant photo gallery permission');
        }
        break;

      default:
    }
    if (currentIndex.value == length -1) {
      Get.offAll(() => ProjectsPageView());
    } else {
      pageController.animateToPage(
        currentIndex.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );

      currentIndex.value++;
      update();
    }
  }
}
