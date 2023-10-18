import 'package:get/get.dart';

import '../controllers/create_chat_controller.dart';

class CreateChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateChatController>(
      () => CreateChatController(),
    );
  }
}
