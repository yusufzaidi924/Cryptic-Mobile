import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/ProjectModel.dart';
import 'package:edmonscan/app/services/api_call_status.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProjectsPageController extends GetxController {
  //TODO: Implement LoginLogController

  // api call status
  ApiCallStatus status = ApiCallStatus.holding;
  final projects = Rx<List<ProjectModel>>([]);
  final ScrollController scrollCtl = ScrollController();

  final deviceID = "".obs;

  /*****************************
   * @Auth: geniusdev0813
   * @Date: 2023.3.10
   * @Desc: Get Projects
   */
  void getProjects() async {
    try {
      status = ApiCallStatus.loading;
      update();

      projects.value = [];
      DatabaseReference productsRef = FirebaseDatabase.instance
          .reference()
          .child(DatabaseConfig.PROJECT_COLLECTION);
      DatabaseEvent event = await productsRef.orderByChild("createdAt").once();

      // Retrieve the DataSnapshot from the event
      DataSnapshot dataSnapshot = event.snapshot;
      Map? values = dataSnapshot.value as Map?;
      if (values != null) {
        values.forEach((key, value) {
          ProjectModel projectModel = ProjectModel.fromJson(value);
          projectModel.id = key;
          projects.value.add(projectModel);
          update();
        });
      } else {
        Logger().e("Data is not exist");
      }
      status = ApiCallStatus.success;
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!', message: e.toString());
      status = ApiCallStatus.error;
      update();
    }
  }

  @override
  void onInit() {
    getProjects();
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
