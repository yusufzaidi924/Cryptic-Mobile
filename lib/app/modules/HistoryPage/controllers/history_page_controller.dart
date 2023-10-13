import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/ProjectModel.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class HistoryPageController extends GetxController {
  //TODO: Implement HistoryPageController

  Rx<List<String>> _imageFiles = Rx<List<String>>([]);
  List<String> get imageFiles => _imageFiles.value;

  getHistory(ProjectModel project) {}

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
