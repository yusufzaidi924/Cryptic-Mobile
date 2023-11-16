import 'dart:convert';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashController extends GetxController
// with WidgetsBindingObserver
{
  //TODO: Implement SplashController

  initApp() async {
    // Call Page Check
    listenerEvent(onEvent);

    final authCtrl = Get.find<AuthController>();
    checkAndNavigationCallingPage(() async {
      String route = await authCtrl.restoreAccount();
      Get.toNamed(route);
    });
  }

  void onEvent(CallEvent event) {
    Logger().i(event.toString());
    // if (!mounted) return;
    // setState(() {
    //   textEvents += '${event.toString()}\n';
    // });
  }

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
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
            checkAndNavigationCallingPage(() {});
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            // await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
            break;
          case Event.actionCallEnded:
            // TODO: ended an incoming/outgoing call
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
  Future<void> checkAndNavigationCallingPage(callback) async {
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
        final jsonData = jsonDecode(data);
        final payload = jsonData['payload'];
        Logger().d(payload);

        final callToken = payload['token'];
        final channelID = payload['channelID'];
        final user = payload['user'];
        final userModel = User.fromJson(user);
        // Logger().i('🌈 ---------- Call Token ------ 🌈');
        // Logger().d(callToken);
        // Logger().d(channelID);

        String? token = await getTokenFromServer(channelID);
        if (token != null) {
          Get.toNamed(Routes.CALL_PAGE, arguments: {
            'user': userModel,
            'token': token,
            'channelID': channelID,
            'callId': callId,
            'role': 'audience'
          });
        }
      } else {
        Logger().e("There is no call");
        // CustomSnackBar.showCustomErrorSnackBar(
        //     title: "ERROR", message: "There is no call");
        // return callback();
      }
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
      await FlutterCallkitIncoming.endAllCalls();
      return callback();
    }
  }

  Future<dynamic> getCurrentCall() async {
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

  Future<void> requestNotificationPermission() async {
    await FlutterCallkitIncoming.requestNotificationPermission({
      "rationaleMessagePermission":
          "Notification permission is required, to show notification.",
      "postNotificationMessageRequired":
          "Notification permission is required, Please allow notification permission from setting."
    });
  }

  /*****************
   * Get Call Token
   */
  Future<String?> getTokenFromServer(String channelName) async {
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   Logger().d('🌈 -- Restore State  --- 🌈 ');
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print('------🔔 APP RESUME -----');
  //       // Code to run when the app is resumed
  //       checkAndNavigationCallingPage(() {});

  //       break;
  //     case AppLifecycleState.inactive:
  //       print('------🔔 APP INACTIVE -----');

  //       // Code to run when the app is inactive
  //       break;
  //     case AppLifecycleState.paused:
  //       print('------🔔 APP PAUSED -----');

  //       // Code to run when the app is paused
  //       break;
  //     case AppLifecycleState.detached:
  //       print('------🔔 APP DETACHED-----');

  //       // Code to run when the app is detached
  //       break;
  //     case AppLifecycleState.hidden:
  //       print('------🔔 APP HIDDEN -----');

  //       // TODO: Handle this case.
  //       break;
  //     default:
  //       break;
  //   }
  // }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  @override
  void onInit() {
    super.onInit();

    // WidgetsBinding.instance.addObserver(this);

    initApp();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
