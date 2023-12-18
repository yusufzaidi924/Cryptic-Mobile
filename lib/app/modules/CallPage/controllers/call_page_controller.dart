import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:uuid/uuid.dart';

class CallPageController extends GetxController {
  //TODO: Implement CallPageController

  final authCtrl = Get.find<AuthController>();
  final _user = Rxn<User>();
  User? get user => _user.value;

  final _estimateTime = Rx<int>(0);
  int get estimateTime => _estimateTime.value;
  bool connecting = false;
  Timer? _timer;
  bool speakerOn = true;
  bool microOn = true;
  bool cameraOn = true;
  bool isFrontCamera = true;
  Timer? get timer => _timer;
  // Start the timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _estimateTime.value++;
      update(); // Update the UI
    });
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
    channelID = params['channelID'];
    callId = params['callId'];
    role = params['role'] ?? 'publisher';
    _init();
  }

  _init() async {
    try {
      connecting = true;
      update();
      callToken = await getTokenFromServer(channelID!);

      connecting = false;
      update();
      await onInitCall();
    } catch (e) {
      connecting = false;
      update();
      await onCancelCall();
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR",
          message: "Something went wrong. Please create call again!");
    }
    await getTokenFromServer(channelID!);
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
      startTimer();
      // _agoraClient.addListener(_agoraClient.subject);
      // _agoraClient.value = client;

      // _agoraClient.stream.listen((event) {
      //   print("stream: $event");
      // });

      // _agoraClient.listen((p0) {
      //   print("listen: $p0");
      //   if ((p0?.users.length ?? 0) > 1 && _timer == null) {

      //   }
      //   if (_timer != null && (p0?.users.length ?? 0) < 2) {
      //     onCancelCall();
      //   }
      // });
      // agoraClient.sessionController.value.agoraRtmChannel.sendMessage2(message);
      // Send Call Request Push Notification
      if (role == 'publisher') {
        // SEND CALL REQUEST NOTIFICATION
        sendCallRequestNotification();
      }

      // Start Call Timer
      // startTimer();

      update();
    } else {
      // Get.back();
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR",
          message: "Something went wrong. Please create call again!");
      // Get.back();
      // _dispose();
      await onCancelCall();
    }
  }

  void _listener(GetStream<AgoraClient?> value) {}
  /***************************************
   * On Cancel Call
   */
  onCancelCall() async {
    try {
      if (callId != null) {
        await FlutterCallkitIncoming.endCall(callId!);
      }
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
    _timer?.cancel();
    await makeEndCall(callId);
  }

  /********************************
   * Send Call Request Notification
   */
  Future<void> sendCallRequestNotification() async {
    if (user != null) {
      var userDetails = await FirebaseFirestore.instance
          .collection(DatabaseConfig.USER_COLLECTION)
          .doc(user!.id)
          .get();
      if (userDetails.exists) {
        Map<String, dynamic> data = userDetails.data() as Map<String, dynamic>;
        Logger().d(data);
        data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
        data['id'] = userDetails.id;
        data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
        data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
        final userModel = User.fromJson(data);
        if (userModel.metadata != null) {
          String callerName =
              '${authCtrl.chatUser?.firstName ?? "Criptacy"} ${authCtrl.chatUser?.lastName ?? "User"}';
          String message = '$callerName is calling you now.';
          String fcmToken = userModel.metadata!['fcm_token'].toString();
          String? voipToken = userModel.metadata!['voip_token'];
          if (voipToken?.isNotEmpty ?? false) {
            await UserRepository.sendVoipNotification(
              voipToken: voipToken!,
              isProduction: !kDebugMode,
              payload: {
                "aps": {"alert": message},
                "id": Uuid().v4(),
                "nameCaller": callerName,
                "handle": "${authCtrl.authUser?.phone}",
                "isVideo": true,
                "extra": {
                  "payload": {
                    "content": {
                      "token": callToken,
                      "channelID": channelID,
                      "user": authCtrl.authUser?.toJson(),
                    }
                  }
                }
              },
            );
          } else {
            await makeConnectCall(callId);
            await FcmHelper.sendCallRequestNotification(
              fcmToken: fcmToken,
              title: "Call Request!",
              message: message,
              largeIcon: '${Network.BASE_URL}${authCtrl.chatUser!.imageUrl}',
              payload: {
                'token': callToken,
                'channelID': channelID,
                'user': authCtrl.chatUser!.toJson()
              },
            );
          }
        }
      } else {
        throw Exception("User not exist");
      }
    }
  }

  Future<void> makeEndCall(id) async {
    // if (id != null)
    await FlutterCallkitIncoming.endAllCalls();
    await agoraClient?.release();
  }

  Future<void> makeConnectCall(id) async {
    if (id != null) await FlutterCallkitIncoming.setCallConnected(id);
  }

  Future<String?> getTokenFromServer(String channelName) async {
    try {
      final res = await AppRepository.getCallToken(
          channelName: channelName, uid: authCtrl.authUser?.id ?? 0);
      Logger().i('🎨🎨🎨------- Agora TOKEN-----🎨🎨🎨');
      Logger().i(res);
      if (res['rtcToken'] != '') {
        String token = res['rtcToken'];
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

  Future<void> muteAudio() async {
    speakerOn = !speakerOn;
    update();
    await agoraClient?.engine.muteAllRemoteAudioStreams(speakerOn);
  }

  Future<void> muteMicro() async {
    microOn = !microOn;
    update();
    await toggleMute(sessionController: agoraClient!.sessionController);
  }

  Future<void> turnOffCamera() async {
    cameraOn = !cameraOn;
    update();
    await toggleCamera(sessionController: agoraClient!.sessionController);
  }

  Future<void> changeCamera() async {
    isFrontCamera = !isFrontCamera;
    update();
    switchCamera(sessionController: agoraClient!.sessionController);
  }
}
