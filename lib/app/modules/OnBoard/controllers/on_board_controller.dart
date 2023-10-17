import 'package:edmonscan/app/data/local/my_shared_pref.dart';
import 'package:edmonscan/app/modules/Auth/views/sign_in_view.dart';
// import 'package:edmonscan/app/modules/Home/views/home_view.dart';
import 'package:edmonscan/app/modules/OnBoard/views/on_board_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class OnBoardController extends GetxController {
  //TODO: Implement OnBoardController

  final count = 0.obs;
  final isLogin = false.obs;

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Register Screen
      // Get.offAll(() => SignInView());
      // Get.offAll(() => OnBoardView());
      MySharedPref.saveData(
          value: false, key: MySharedPref.IS_LOGIN, type: PrefType.BOOL);
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      // Get.offAll(() => HomeView());
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
