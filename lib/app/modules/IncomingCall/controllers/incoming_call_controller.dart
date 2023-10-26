import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/CallPage/views/testCall.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class IncomingCallController extends GetxController {
  //TODO: Implement IncomingCallController

  final authCtrl = Get.find<AuthController>();

  final player = AudioPlayer();

  final count = 0.obs;
  final _user = Rxn<User>();
  User? get user => _user.value;
  String? callToken;
  String? channelID;
  String? callId;

  @override
  void onInit() {
    super.onInit();
    // playRing();
    final params = Get.arguments;
    print("🏆================= INCOMING CALL ============== 🏆");
    Logger().d(params);
    if (params != null) {
      callId = params['id'];
      Logger().d(callId);
      final data = params['extra']['content'];

      // Logger().d(data);
      final jsonPayload = jsonDecode(data);
      final payload = jsonPayload['payload'];
      Logger().d(payload);

      callToken = payload['token'];
      channelID = payload['channelID'];

      Logger().i('🌈 ---------- Call Token ------🌈');
      Logger().d(callToken);
      Logger().d(channelID);
      final user = payload['user'];
      _user.value = User.fromJson(user);
    }

    update();
  }

  playRing() async {
    try {
      // player.setReleaseMode(ReleaseMode.loop);

      // player.setReleaseMode(ReleaseMode.loop);
      int repeatCount = 0;
      await player.play(
          AssetSource(
            'audios/ringing.mp3',
          ),
          mode: PlayerMode.mediaPlayer);

      player.onPlayerComplete.listen((_) async {
        repeatCount++;

        Logger().i(repeatCount);
        if (repeatCount < 2) {
          await player.play(
              AssetSource(
                'audios/ringing.mp3',
              ),
              mode: PlayerMode.mediaPlayer);
        } else {
          await stopRing();
        }
      });
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  stopRing() async {
    try {
      if (player != null) {
        await player.stop();
        await player.dispose();
      }
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  /******************************
   * onCancelCall
   */
  onCancelCall() async {
    // try {
    //   await stopRing();
    // } catch (e) {
    //   Logger().e(e.toString());
    // }
    await makeEndCall(callId);
    // Get.back();
    if (authCtrl.authUser == null || authCtrl.btcService == null) {
      Get.offAllNamed(Routes.SIGN_IN);
    } else {
      Get.offNamed(Routes.HOME);
    }
  }

  Future<void> makeEndCall(id) async {
    await FlutterCallkitIncoming.endCall(id);
  }

  Future<void> makeConnectCall(id) async {
    await FlutterCallkitIncoming.setCallConnected(id);
  }

  onAcceptCall() async {
    if (callId != null &&
        user != null &&
        callToken != null &&
        channelID != null) {
      await makeConnectCall(callId);

      String? token = await getTokenFromServer(channelID!);
      if (token != null) {
        Get.offNamed(Routes.CALL_PAGE, arguments: {
          // Get.toNamed(Routes.CALL_PAGE, arguments: {
          'user': user,
          'token': token,
          'channelID': channelID,
          'callId': callId,
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
    // stopRing();
    super.onClose();
  }

  void increment() => count.value++;
}
