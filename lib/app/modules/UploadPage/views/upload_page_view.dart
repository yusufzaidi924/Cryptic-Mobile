import 'dart:io';

import 'package:edmonscan/app/components/back_widget.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/ProjectModel.dart';
import 'package:edmonscan/app/modules/HistoryPage/views/history_page_view.dart';
import 'package:edmonscan/app/modules/PhotoPreview/views/photo_preview_view.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/upload_page_controller.dart';
import 'image_preview.dart';

class UploadPageView extends GetView<UploadPageController> {
  UploadPageView({Key? key, required this.project}) : super(key: key);
  final ProjectModel project;
  UploadPageController controller = Get.put(UploadPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadPageController>(
        // init: UploadPageController(),
        builder: (_) {
      return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          leading: BackWidget(onTap: () async {
            Get.back();
            controller.onClose();
          }),
          title: Text(project.title),
          centerTitle: true,
          actions: [
            CupertinoButton(
              onPressed: () {
                Get.to(HistoryPageView(project: project));
              },
              padding: const EdgeInsets.all(0),
              child: Container(
                padding: const EdgeInsets.all(0),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: MyColors.primaryButtonColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: Container(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                  child: imageTileList(),
                ),
                SizedBox(height: 24.0),
                MaterialButton(
                  color: MyColors.primaryButtonColor,
                  minWidth: double.infinity,
                  onPressed: () {
                    controller.showBottomSheet(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 45,
                  child: Text(
                    controller.imageFiles.isEmpty
                        ? 'Choose Photo'
                        : "Choose another photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  color: controller.imageFiles.isEmpty
                      ? MyColors.grey
                      : MyColors.red,
                  minWidth: double.infinity,
                  onPressed: () {
                    if (controller.imageFiles.isEmpty) {
                      CustomSnackBar.showCustomErrorSnackBar(
                          title: 'Warning!', message: 'Please select an image');
                    }
                    controller.uploadImage(project);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 45,
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget imageTileList() {
    return GridView.builder(
      itemCount: controller.imageFiles.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of columns
        mainAxisSpacing: 10.0, // space between rows
        crossAxisSpacing: 10.0, // space between columns
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index < controller.imageFiles.length) {
          return imageTile(controller.imageFiles[index]);
        } else {
          return addMoreTile(context);
        }
      },
    );
  }

  Widget imageTile(File image) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Get.to(ImagePreviewPage(
              path: image.path,
              isNetwork: false,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: FileImage(image), // replace with your own image source
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
            top: 2,
            right: 3,
            child: InkWell(
              onTap: () {
                controller.removeImage(image);
              },
              child: CircleAvatar(
                radius: 10,
                backgroundColor: MyColors.red,
                child: Icon(Icons.close, color: MyColors.white, size: 10),
              ),
            ))
      ],
    );
  }

  Widget addMoreTile(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.showBottomSheet(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.white, width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          color: MyColors.primaryButtonColor,
          size: 30,
        ),
      ),
    );
  }
}
