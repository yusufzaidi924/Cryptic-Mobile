import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/my_profile_view.dart';

class MyProfileController extends GetxController {
  //TODO: Implement MyProfileController

  final authCtrl = Get.find<AuthController>();

  List menuList = [
    menuItem(
        icon: Icon(
          Icons.wallet_outlined,
          color: Colors.black,
        ),
        title: "Cards/Bank Accounts",
        route: Routes.ADD_NEW_CARD),
    menuItem(
        icon: Icon(
          Icons.trending_up_rounded,
          color: Colors.black,
        ),
        title: "Trending",
        route: Routes.TRENDING),
    menuItem(
        icon: Icon(
          Icons.join_full_outlined,
          color: Colors.black,
        ),
        title: "Affilate Service",
        route: Routes.AFFILIATE_PAGE),
    menuItem(
        icon: Icon(
          Icons.people_outline,
          color: Colors.black,
        ),
        title: "Manage Contacts",
        route: Routes.FRIENDS),
    menuItem(
        icon: Icon(
          Icons.lock_outline,
          color: Colors.black,
        ),
        title: "Account Security",
        route: Routes.ACCOUNT_SECURITY),
    menuItem(
        icon: Icon(
          Icons.settings_outlined,
          color: Colors.black,
        ),
        title: "Settings",
        route: Routes.SETTING_PAGE),
  ];

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

  onLogout() async {
    var user = authCtrl.authUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection(DatabaseConfig.USER_COLLECTION)
            .doc("${user.id}")
            .update({"metadata.fcm_token": "", "metadata.voip_token": ""});
      } catch (e) {}
    }

    await authCtrl.logout();
  }
}
