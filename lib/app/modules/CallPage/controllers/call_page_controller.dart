import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_uikit/agora_uikit.dart';

class CallPageController extends GetxController {
  //TODO: Implement CallPageController

  final authCtrl = Get.find<AuthController>();
  final _user = Rxn<User>();
  User? get user => _user.value;

  final _estimateTime = Rx<int>(0);
  int get estimateTime => _estimateTime.value;

  Timer? _timer;
  // Start the timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _estimateTime.value++;
      update(); // Update the UI
    });
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
    _estimateTime.value = 0;
    update(); // Update the UI
  }

  // Agora Client
  final _agoraClient = Rxn<AgoraClient>();
  AgoraClient? get agoraClient => _agoraClient.value;

  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments;

    print('🎧🎧🎧 ----- CALL PAGE ----');
    Logger().d(params);

    _user.value = params['user'];
    callToken = params['token'];
    channelID = params['channelID'];
    callId = params['callId'];
    role = params['role'] ?? 'publisher';
    onInitCall();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _dispose();
  }

  /***********************************
   * On Init Call
   */
  onInitCall() async {
    await makeConnectCall(callId);

    if (callToken != null && channelID != null) {
      final AgoraClient client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: ArgoraConf.APPID,
          channelName: channelID!,
          tempToken: callToken,
          uid: authCtrl.authUser?.id ?? 0,
        ),
      );
      await client.initialize();
      _agoraClient.value = client;

      // Send Call Request Push Notification
      if (role == 'publisher') {
        // SEND CALL REQUEST NOTIFICATION
        sendCallRequestNotification();
      }

      // Start Call Timer
      startTimer();

      update();
    } else {
      // Get.back();
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR",
          message: "Something went wrong. Please create call again!");
      // Get.back();
    }
  }

  /***************************************
   * On Cancel Call
   */
  onCancelCall() async {
    try {
      await _dispose();
    } catch (e) {
      Logger().e(e.toString());
    }

    if (authCtrl.authUser == null || authCtrl.btcService == null) {
      Get.offAllNamed(Routes.SIGN_IN);
    } else {
      // Get.offNamed(Routes.HOME);
      Get.back();
    }
  }

  String? channelID;
  String? callToken;
  String? callId;
  String role = 'publisher';

  /****************************
   * Call Dispose
   */
  Future<void> _dispose() async {
    Logger().d(callId);
    await makeEndCall(callId);
  }

  /********************************
   * Send Call Request Notification
   */
  Future<void> sendCallRequestNotification() async {
    if (user != null &&
        user?.metadata != null &&
        user?.metadata?['fcm_token'] != null) {
      String fcmToken = user!.metadata!['fcm_token'].toString();
      FcmHelper.sendCallRequestNotification(
        fcmToken: fcmToken,
        title: "Call Request!",
        message:
            '${authCtrl.chatUser?.firstName ?? "Criptacy"} ${authCtrl.chatUser?.lastName ?? "User"} is calling you now.',
        largeIcon: '${Network.BASE_URL}${authCtrl.chatUser!.imageUrl}',
        payload: {
          'token': callToken,
          'channelID': channelID,
          'user': authCtrl.chatUser!.toJson()
        },
      );
    }
  }

  Future<void> makeEndCall(id) async {
    // if (id != null)
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> makeConnectCall(id) async {
    if (id != null) await FlutterCallkitIncoming.setCallConnected(id);
  }
}
