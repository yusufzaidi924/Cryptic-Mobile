import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final _isEnableCamera = false.obs;
  bool get isEnableCamera => _isEnableCamera.value;
  onUpdateCamera({isShowAlert = true}) async {
    if (isEnableCamera) // Camera Off Request
    {
      // rtcEngine!.disableVideo();
      if (rtcEngine != null) {
        rtcEngine!.enableLocalVideo(false);
      }

      _isEnableCamera.value = false;
    } else {
      // Camera Open Request
      if (await Permission.camera.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        _isEnableCamera.value = true;
        debugPrint('👌 Camera Permission Granted');
        if (rtcEngine != null) {
          rtcEngine!.enableLocalVideo(true);
        }
      } else {
        debugPrint('😜 Camera Permission Denied');
        _isEnableCamera.value = false;
        if (isShowAlert) {
          showPermissionDeniedDialog("Camera");
        }
      }
    }
    update();
  }

  void showPermissionDeniedDialog(String item) {
    Get.dialog(
      AlertDialog(
        title: Text('${item} Permission denied'),
        content: Text('Please grant ${item} permission to use this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  var isFullScreen = false.obs;
  toggleTap() {
    isFullScreen.toggle();
  }

  final _isEnableMic = false.obs;
  bool get isEnableMic => _isEnableMic.value;
  onUpdateMic({isShowAlert = true}) async {
    if (isEnableMic) // Mic Off Request
    {
      _isEnableMic.value = false;
    } else {
      // Mic Open Request
      if (await Permission.microphone.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        _isEnableMic.value = true;
        debugPrint('👌 Mic Permission Granted');
      } else {
        debugPrint('😜 Mic Permission Denied');
        _isEnableMic.value = false;
        if (isShowAlert) {
          showPermissionDeniedDialog("Microphone");
        }
      }
    }
    update();
  }

  final _isEnableSwitchCam = false.obs;
  bool get isEnableSwitchCam => _isEnableSwitchCam.value;
  onSwitchCamera() async {
    if (rtcEngine != null) {
      Logger().i('----------- SWITCH CAMERA ---------');
      await rtcEngine!.switchCamera();
      _isEnableSwitchCam.value = !_isEnableSwitchCam.value;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments;
    _user.value = params['user'];
    callToken = params['token'];
    channelID = params['channelID'];
    role = params['role'] ?? 'publisher';

    // onInitCall();
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
      await initAgora(callToken!, channelID!);
    } else {
      // Get.back();
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR",
          message: "Something went wrong. Please create call again!");
      // Get.back();
    }
  }

  /****************************************
   * On Create Call
   */
  onCreateCall() async {}

  /***************************************
   * On Cancel Call
   */
  onCancelCall() async {
    await _dispose();
    Get.back();
  }

  ///////////////////////// Agora Video Call  ///////////////////////////
  final _engine = Rxn<RtcEngine>();
  RtcEngine? get rtcEngine => _engine.value;

  final _isLocalUserJoin = Rx<bool>(false);
  bool get isLocalUserJoin => _isLocalUserJoin.value;

  final _remoteUserUID = Rxn<int>(null);
  int? get remoteUserUID => _remoteUserUID.value;

  String? channelID;
  String? callToken;
  String role = 'publisher';

  /************************
   * Init Argora Engine
   */
  Future<void> initAgora(String token, String channelName) async {
    Logger().i('🎁 ------- Agora Init ----------✨');
    await onUpdateCamera(isShowAlert: false);
    await onUpdateMic(isShowAlert: false);
    // retrieve permissions
    // await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine.value = createAgoraRtcEngine();
    await rtcEngine!.initialize(const RtcEngineContext(
      appId: ArgoraConf.APPID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    print('************** RTC Engine End Create ***********');

    rtcEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          Logger().e('[onError] err: $err, msg: $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Logger().i("local user ${connection.localUid} joined");

          _isLocalUserJoin.value = true;
          startTimer();
          update();

          if (role == 'publisher') {
            // SEND CALL REQUEST NOTIFICATION
            sendCallRequestNotification();
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Logger().i("remote user $remoteUid joined");

          _remoteUserUID.value = remoteUid;

          // Move Local Camera to Top Right Corner

          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          Logger().e("remote user $remoteUid left channel");

          _remoteUserUID.value = null;

          // Restore Local Camear As Full Screen

          update();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          Logger().i(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    print('************** RTC Engine Event Register ***********');

    // if (role == 'publisher') {
    await rtcEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // } else {
    //   await rtcEngine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    // }
    await rtcEngine!.enableVideo();
    await rtcEngine!.startPreview();

    print('************** RTC Engine conf eng 🚒 ***********');
    print(token);
    print(channelName);
    await rtcEngine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: int.parse(authCtrl.chatUser?.id ?? '0'),
      options: const ChannelMediaOptions(),
    );
  }

  /****************************
   * Init Dispose
   */
  Future<void> _dispose() async {
    if (rtcEngine != null) {
      EasyLoading.show(status: "Ending...");
      await rtcEngine!.leaveChannel();
      // await rtcEngine!.release();
      EasyLoading.dismiss();
    }
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
        largeIcon: 'https://placebear.com/g/200/300',
        payload: {
          'token': callToken,
          'channelID': channelID,
          'user': authCtrl.chatUser!.toJson()
        },
      );
    }
  }
}
