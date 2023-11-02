import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../views/setting_page_view.dart';

class SettingPageController extends GetxController {
  //TODO: Implement SettingPageController

  final authCtrl = Get.find<AuthController>();
  final avatar = Rxn<String>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final fullnameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  /******************
   * Change Avatar
   */
  pickAvatar() async {
    await showBottomSheetIDPhoto();
  }

  /********************************
   * Show BottomSheet Choose Photo
   */
  showBottomSheetIDPhoto() async {
    return showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickPhoto(ImageSource.camera);
                },
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text("Take a photo")),
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickPhoto(ImageSource.gallery);
                },
                leading: Icon(
                  Icons.folder_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text("Choose from Gallery")),
          ],
        );
      },
    );
  }

  /**************************
   * Pick Photo
   */
  Future<void> pickPhoto(ImageSource source) async {
    if (source == ImageSource.camera) {
      await requestCameraPermission();
    } else if (source == ImageSource.gallery) {
      await requestGalleryPermission();
    }
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      File pickedFile = File(pickedImage.path);
      String? filePath = await uploadFile(pickedFile);
      if (filePath != null) {
        avatar.value = filePath;
      }
      update();
    }
  }

  /*******************
   * Upload File
   */
  Future<String?> uploadFile(File file) async {
    EasyLoading.show();
    try {
      final res = await UserRepository.uploadFile(file);
      Logger().i(res);
      if (res.statusCode == 200) {
        final responseData = await res.stream.bytesToString();

        final data = jsonDecode(responseData);
        Logger().i(data);

        EasyLoading.dismiss();

        return data['data']['filePath'];
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
      return null;
    }
  }

  validateFullname(String? value) {
    if (value == null || value == '') {
      return "Please enter full name";
    } else if (!Regex.isValidFullName(value)) {
      return "Invalid full name";
    }
    return null;
  }

  /****************************
   * Validate  Email
   */
  validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required.';
    } else if (!Regex.isEmail(value!)) {
      return 'Email format invalid.';
    }

    return null;
  }

  /********************************
   * Save Changes
   */
  onSaveChanges() async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        EasyLoading.show();
        String fullName = fullnameCtrl.text;
        final nameArr = fullName.split(" ");

        final data = {
          // "uid": authCtrl.authUser!.id,
          "selfie": avatar.value,
          'first_name': nameArr[0],
          'last_name': nameArr[1],
          'email': emailCtrl.text,
        };

        final res =
            await UserRepository.updateUser(authCtrl.authUser!.id, data);

        Logger().i(res);
        if (res['statusCode'] == 200) {
          UserModel newUser = authCtrl.authUser!;
          newUser.firstName = nameArr[0];
          newUser.lastName = nameArr[1];
          newUser.selfie = avatar.value;
          authCtrl.updateAuthUser(newUser);

          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS",
              message: "Your profile is updated successfully!");
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
    avatar.value = authCtrl.authUser?.selfie;
    fullnameCtrl.text =
        "${authCtrl.authUser?.firstName} ${authCtrl.authUser?.lastName}";
    phoneCtrl.text = "${authCtrl.authUser?.phone}";
    emailCtrl.text = "${authCtrl.authUser?.email}";
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
