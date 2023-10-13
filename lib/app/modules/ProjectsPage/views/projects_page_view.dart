import 'package:edmonscan/app/components/myDrawer.dart';
import 'package:edmonscan/app/components/my_widgets_animator.dart';
import 'package:edmonscan/app/data/models/ProjectModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/ProjectsPage/controllers/projects_page_controller.dart';
import 'package:edmonscan/app/modules/UploadPage/views/upload_page_view.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';

class ProjectsPageView extends GetView<ProjectsPageController> {
  const ProjectsPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectsPageController());
    // controller.getLoginActivity();
    return GetBuilder<ProjectsPageController>(
      init: ProjectsPageController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Projects",
              style: TextStyle(
                color: MyColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              GetBuilder<AuthController>(
                  init: AuthController(),
                  builder: (authCtl) {
                    return IconButton(
                        onPressed: () {
                          authCtl.signOut();
                        },
                        icon: Icon(
                          FontAwesome.sign_out,
                          color: MyColors.red,
                          size: 25,
                        ));
                  })
            ],
          ),
          // drawer: myDrawer(),
          body: Container(
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: MyWidgetsAnimator(
              apiCallStatus: controller.status,
              loadingWidget: () => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: () => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Something went wrong",
                      style: TextStyle(fontSize: 14, color: MyColors.red),
                    ),
                    MaterialButton(
                      color: MyColors.primaryButtonColor,
                      onPressed: () {
                        controller.getProjects();
                      },
                      child: Text("RETRY"),
                    ),
                  ],
                ),
              ),
              successWidget: () => controller.projects.value.isNotEmpty
                  ? ListView.builder(
                      controller: controller.scrollCtl,
                      itemCount: controller.projects.value.length,
                      itemBuilder: (context, index) {
                        ProjectModel event = controller.projects.value[index];

                        return _activityWidget(event);
                      })
                  : Center(
                      child: Text(
                        "No Projects",
                        style: TextStyle(fontSize: 16, color: MyColors.white),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  ////////////////
  Widget _activityWidget(ProjectModel project) {
    String createdAt =
        formatDateTime(project.createdAt, format: "MM/dd/yyyy hh:mm");
    String updatedAt =
        formatDateTime(project.updatedAt, format: "MM/dd/yyyy hh:mm");

    return InkWell(
      onTap: () {
        Get.to(UploadPageView(
          project: project,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: MyColors.backgroundColor1,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${createdAt.toString()}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   "Inactive",
                  //   style: TextStyle(
                  //       color: Color(0XFF72D061),
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  Get.to(UploadPageView(
                    project: project,
                  ));
                },
                icon: Icon(
                  FontAwesome.arrow_circle_o_right,
                  color: MyColors.primaryButtonColor,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
