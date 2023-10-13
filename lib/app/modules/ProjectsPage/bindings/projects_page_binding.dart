import 'package:get/get.dart';

import '../controllers/projects_page_controller.dart';

class ProjectsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectsPageController>(
      () => ProjectsPageController(),
    );
  }
}
