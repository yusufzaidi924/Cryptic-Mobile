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

class UploadPageController extends GetxController {
  //TODO: Implement UploadPageController

  Rx<List<File>> _imageFiles = Rx<List<File>>([]);
  final _uploadProgress = Rx<int>(0);
  List<File> get imageFiles => _imageFiles.value;
  int get uploadProgress => _uploadProgress.value;
  List<String> storedImgUrls = [];

  Future<void> pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await requestCameraPermission();
    } else if (source == ImageSource.gallery) {
      await requestGalleryPermission();
    }
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      _imageFiles.value.add(File(pickedImage.path));
      update();
    }
  }

  showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickImage(ImageSource.camera);
                },
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: MyColors.primaryButtonColor,
                ),
                title: Text("Take a photo")),
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickImage(ImageSource.gallery);
                },
                leading: Icon(
                  Icons.folder_outlined,
                  color: MyColors.primaryButtonColor,
                ),
                title: Text("Choose from Gallery")),
          ],
        );
      },
    );
  }

  removeImage(File image) async {
    _imageFiles.value.removeAt(_imageFiles.value.indexOf(image));
    update();
  }

  Future<void> uploadImage(ProjectModel project) async {
    if (imageFiles.isEmpty) {
      Logger().e("Image Value is Null");
      return;
    }

    EasyLoading.show(status: "Uploading: ${uploadProgress}%");
    try {
      List<File> copyList = List.from(imageFiles);
      int i = 0;
      for (File image in copyList) {
        final storageRef = FirebaseStorage.instance.ref().child(
            '${DatabaseConfig.STORAGE_IMAGE_COLLECTION}/${project.id}/${DateTime.now()}.png');

        final UploadTask uploadTask = storageRef.putFile(image);

        uploadTask.snapshotEvents.listen((event) async {
          int progress =
              (event.bytesTransferred / event.totalBytes).toInt() * 100;

          _uploadProgress.value =
              ((i * 100 + progress) / imageFiles.length * 100).toInt();
          update();
          print('Progress: $progress');
        });
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
          Logger().i("Upload completed successfully");
          i++;
          _uploadProgress.value = (i * 100 / imageFiles.length).toInt();

          removeImage(image);

          update();
        });

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        storedImgUrls.add(imageUrl);
      }

      // Save Uploaded Image Data into Real-Time Database
      await saveUploadedImageData(storedImgUrls, project);
      EasyLoading.dismiss();
      CustomSnackBar.showCustomSnackBar(
          title: 'SUCCESS', message: 'Uploaded successfully!');
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
    }
  }

  saveUploadedImageData(List<String> imgPaths, ProjectModel project) async {
    // final databaseReference = FirebaseDatabase.instance
    //     .reference()
    //     .child('${DatabaseConfig.PAPER_COLLECTION}/document_id');

    // databaseReference.update({
    //   'list_field': FieldValue.arrayUnion(['new_value'])
    // });
    storedImgUrls = [];
  }

  init() {
    _imageFiles.value = [];
    storedImgUrls = [];
    _uploadProgress.value = 0;
    // update();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    init();
    print("UploadController closed!");
    super.onClose();
  }
}
