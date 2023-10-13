import 'package:get/get.dart';

import '../controllers/my_p_m_page_controller.dart';

class MyPMPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPMPageController>(
      () => MyPMPageController(),
    );
  }
}
