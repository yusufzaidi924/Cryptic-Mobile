import 'package:get/get.dart';

import '../controllers/mnemonic_page_controller.dart';

class MnemonicPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MnemonicPageController>(
      () => MnemonicPageController(),
    );
  }
}
