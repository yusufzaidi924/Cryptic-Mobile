import 'package:get/get.dart';

import '../controllers/upload_page_controller.dart';

class UploadPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadPageController>(
      () => UploadPageController(),
    );
  }
}
