import 'dart:io';

import 'package:edmonscan/app/components/back_widget.dart';
import 'package:edmonscan/app/data/models/ProjectModel.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../UploadPage/views/image_preview.dart';
import '../controllers/history_page_controller.dart';

class HistoryPageView extends GetView<HistoryPageController> {
  HistoryPageView({Key? key, required this.project}) : super(key: key);
  final ProjectModel project;
  HistoryPageController controller = Get.put(HistoryPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryPageController>(
        init: controller.getHistory(project),
        builder: (_) {
          return Scaffold(
            // backgroundColor: Colors.black,
            appBar: AppBar(
              leading: BackWidget(onTap: () async {
                Get.back();
                controller.onClose();
              }),
              title: Text("${project.title} - Photos"),
              centerTitle: true,
            ),
            body: Container(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Expanded(
                      child: controller.imageFiles.isNotEmpty
                          ? imageTileList()
                          : noImages(context),
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
      itemCount: controller.imageFiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of columns
        mainAxisSpacing: 10.0, // space between rows
        crossAxisSpacing: 10.0, // space between columns
      ),
      itemBuilder: (BuildContext context, int index) {
        return imageTile(controller.imageFiles[index]);
      },
    );
  }

  Widget imageTile(String image) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Get.to(ImagePreviewPage(
              path: image,
              isNetwork: true,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image:
                    NetworkImage(image), // replace with your own image source
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
                // controller.removeImage(image);
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

  Widget noImages(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            color: MyColors.primaryButtonColor,
            size: 40,
          ),
          Text(
            "No Uploaded Images",
            style: TextStyle(
              color: MyColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
