import 'dart:convert';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class CallKitHelper {
  static Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        print('🎁------------>');
        if (event != null) {
          Logger().d('SPLASH: ${event?.event}');
        }
        switch (event!.event) {
          case Event.actionCallIncoming:
            // TODO: received an incoming call
            break;
          case Event.actionCallStart:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.actionCallAccept:

            // TODO: accepted an incoming call
            // TODO: show screen calling in Flutter
            await checkAndNavigationCallingPage(() {});
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            // await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
            break;
          case Event.actionCallEnded:
            FlutterCallkitIncoming.endAllCalls();
            break;
          case Event.actionCallTimeout:
            // TODO: missed an incoming call
            break;
          case Event.actionCallCallback:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.actionCallToggleHold:
            // TODO: only iOS
            break;
          case Event.actionCallToggleMute:
            // TODO: only iOS
            break;
          case Event.actionCallToggleDmtf:
            // TODO: only iOS
            break;
          case Event.actionCallToggleGroup:
            // TODO: only iOS
            break;
          case Event.actionCallToggleAudioSession:
            // TODO: only iOS
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            // TODO: only iOS
            break;
          case Event.actionCallCustom:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print('🎃🎃🎃------------>');
      Logger().e(e);
    }
  }

  //////////////////////// INCOMING CALL //////////////////
  static Future<void> checkAndNavigationCallingPage(callback) async {
    try {
      // await requestNotificationPermission();

      var currentCall = await getCurrentCall();
      if (currentCall != null) {
        // NavigationService.instance
        //     .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
        print(" 🏆================= INCOMING CALL ============== 🏆");
        Logger().d(currentCall);
        final callId = currentCall['id'];

        final data = currentCall['extra']['payload']['content'];
        Map<String, dynamic> payload = {};
        if (data is Map) {
          payload = Map<String, dynamic>.from(data);
        } else if (data is String) {
          final jsonData = jsonDecode(data);
          payload = jsonData['payload'];
        }

        final callToken = payload['token'];
        final channelID = payload['channelID'];
        var userData = Map<String, dynamic>.from(payload['user']);
        userData.addAll({"metadata": <String, dynamic>{}});
        final userModel = User.fromJson(userData);

        String? token = await getTokenFromServer(channelID);
        if (token != null) {
          if (Get.rawRoute?.settings.name != Routes.CALL_PAGE) {
            Get.toNamed(Routes.CALL_PAGE, arguments: {
              'user': userModel,
              'token': token,
              'channelID': channelID,
              'callId': callId,
              'role': 'audience'
            });
          }
        }
      } else {
        Logger().e("There is no call");
        // CustomSnackBar.showCustomErrorSnackBar(
        //     title: "ERROR", message: "There is no call");
        return callback();
      }
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
      await FlutterCallkitIncoming.endAllCalls();
      return callback();
    }
  }

  static Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        // Logger().d('DATA: $calls');
        // _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        // _currentUuid = "";
        return null;
      }
    }
  }

  /*****************
   * Get Call Token
   */
  static Future<String?> getTokenFromServer(String channelName) async {
    try {
      final res =
          await AppRepository.getCallToken(channelName: channelName, uid: 0);
      Logger().i('🎨🎨🎨------- Agora TOKEN-----🎨🎨🎨');
      Logger().i(res['rtcToken']);
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

  static Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  static showCallRequestNotification(
      {required String title,
      required String body,
      required int id,
      // String? summary,
      // List<NotificationActionButton>? actionButtons,
      Map<String, String>? payload,
      String? largeIcon}) async {
    String _currentUuid = Uuid().v4();

    final params = CallKitParams(
      id: _currentUuid,
      nameCaller: title,
      appName: 'Cryptacy',
      avatar: largeIcon,
      handle: body,
      type: 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: {
        "expireTime": DateTime.now().millisecondsSinceEpoch + 30000,
        'payload': payload
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        // backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
