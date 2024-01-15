import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashController extends GetxController
// with WidgetsBindingObserver
{
  //TODO: Implement SplashController

  initApp() async {
    // Call Page Check
    // listenerEvent(onEvent);

    final authCtrl = Get.find<AuthController>();
    String route = await authCtrl.restoreAccount();
    Get.toNamed(route);
    // checkAndNavigationCallingPage(() async {
    //   String route = await authCtrl.restoreAccount();
    //   Get.toNamed(route);
    // });
  }

  void onEvent(CallEvent event) {
    Logger().i(event.toString());
    // if (!mounted) return;
    // setState(() {
    //   textEvents += '${event.toString()}\n';
    // });
  }

  @override
  void onInit() {
    super.onInit();

    initApp();
  }
}
