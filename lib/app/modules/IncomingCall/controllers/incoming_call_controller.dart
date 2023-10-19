import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class IncomingCallController extends GetxController {
  //TODO: Implement IncomingCallController

  final count = 0.obs;
  final _user = Rxn<User>();
  User? get user => _user.value;
  String? callToken;
  String? channelID;
  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments;
    final data = params['data'];
    print(params['data']);
    final payload = data['payload'];
    callToken = payload['token'];
    channelID = payload['channelID'];

    Logger().i('🌈 ---------- Call Token ------🌈');
    Logger().d(callToken);
    final user = payload['user'];
    _user.value = User.fromJson(user);
    update();
  }

  /******************************
   * onCancelCall
   */
  onCancelCall() async {}

  onAcceptCall() async {
    if (user != null && callToken != null && channelID != null) {
      Get.offNamed(Routes.CALL_PAGE, arguments: {
        'user': user,
        'token': callToken,
        'channelID': channelID
      });
    } else {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "CALL ERROR", message: "Something went wrong! Please retry!");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
