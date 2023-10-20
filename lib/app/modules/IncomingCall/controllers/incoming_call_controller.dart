import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/CallPage/views/testCall.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
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
    Logger().d(channelID);
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
      String? token = await getTokenFromServer(channelID!);
      if (token != null) {
        Get.offNamed(Routes.CALL_PAGE, arguments: {
          // Get.toNamed(Routes.CALL_PAGE, arguments: {
          'user': user,
          'token': token,
          'channelID': channelID,
          'role': 'audience'
        });
      }
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(builder: (context) => JoinChannelVideo()),
      // );
    } else {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "CALL ERROR", message: "Something went wrong! Please retry!");
    }
  }

  /*****************
   * Get Call Token
   */
  Future<String?> getTokenFromServer(String channelName) async {
    try {
      final authCtrl = Get.find<AuthController>();
      // if(authCtrl!= null)
      final data = {
        'channelId': channelName,
        'uid': authCtrl.chatUser?.id ?? 0,
        'role': 'audience'
      };

      final res = await AppRepository.getCallToken(data);
      Logger().i(res);
      if (res['statusCode'] == 200) {
        String token = res['data']['token'];
        Logger().i(token);
        return token;
      } else {
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        return null;
      }
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
      return null;
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
