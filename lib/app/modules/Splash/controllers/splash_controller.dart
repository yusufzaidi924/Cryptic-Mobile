import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  initApp() async {
    // Call Page Check
    final authCtrl = Get.find<AuthController>();
    await authCtrl.checkAndNavigationCallingPage();
  }

  @override
  void onInit() {
    super.onInit();
    initApp();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
