import 'package:get/get.dart';

import '../controllers/photo_preview_controller.dart';

class PhotoPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoPreviewController>(
      () => PhotoPreviewController(),
    );
  }
}
