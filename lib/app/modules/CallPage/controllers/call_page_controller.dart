import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPageController extends GetxController {
  //TODO: Implement CallPageController

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
      _isEnableCamera.value = false;
    } else {
      // Camera Open Request
      if (await Permission.camera.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        _isEnableCamera.value = true;
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

  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments;
    _user.value = params['user'];
    channelID = params['roomID'] ?? "CritacyCallChannel";
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
    await initAgora();
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

  String channelID = '';
  /************************
   * Init Argora Engine
   */
  Future<void> initAgora() async {
    Logger().i('🎁 ------- Agora Init ----------✨');
    await onUpdateCamera(isShowAlert: false);
    await onUpdateCamera(isShowAlert: false);
    // retrieve permissions
    // await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine.value = createAgoraRtcEngine();
    await rtcEngine!.initialize(const RtcEngineContext(
      appId: ArgoraConf.APPID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    rtcEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Logger().i("local user ${connection.localUid} joined");

          _isLocalUserJoin.value = true;
          startTimer();
          update();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Logger().i("remote user $remoteUid joined");

          _remoteUserUID.value = remoteUid;
          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          Logger().e("remote user $remoteUid left channel");

          _remoteUserUID.value = null;
          update();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          Logger().i(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await rtcEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await rtcEngine!.enableVideo();
    await rtcEngine!.startPreview();

    await rtcEngine!.joinChannel(
      token: ArgoraConf.TOKEN,
      channelId: channelID,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _dispose() async {
    if (rtcEngine != null) {
      await rtcEngine!.leaveChannel();
      await rtcEngine!.release();
    }
  }
}
