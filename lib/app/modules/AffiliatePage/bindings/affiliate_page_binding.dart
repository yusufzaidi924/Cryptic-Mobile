import 'package:get/get.dart';

import '../controllers/affiliate_page_controller.dart';

class AffiliatePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AffiliatePageController>(
      () => AffiliatePageController(),
    );
  }
}
