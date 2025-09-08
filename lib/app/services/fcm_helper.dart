import 'dart:convert';
import 'dart:io';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:edmonscan/app/data/local/my_shared_pref.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';

import 'package:edmonscan/app/services/call_kit_helper.dart';

import 'package:edmonscan/utils/constants.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

class FcmHelper {
  static const String FCM_SERVER_KEY =
      "";

  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core

      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleNotificationTap(event.data.cast());
      });
      await CallKitHelper.checkAndNavigationCallingPage(() {});
      await CallKitHelper.listenerEvent((p0) {});

      await FlutterCallkitIncoming.requestNotificationPermission({
        "rationaleMessagePermission":
            "Notification permission is required, to show notification.",
        "postNotificationMessageRequired":
            "Notification permission is required, Please allow notification permission from setting."
      });
    } catch (error) {
      // if you are connected to firebase and still get error
      // check the todo up in the function else ignore the error
      // or stop fcm service from main.dart class
      Logger().e(error);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    var payload = message.data.cast();
    String type = payload['type']!;
    if (type == MessageType.CALL) {
      CallKitHelper.showCallRequestNotification(
        id: message.hashCode,
        title: message.notification?.title ?? 'Title',
        body: message.notification?.body ?? 'Body',
        payload: message.data.cast(),
      );
    } else {
      handleNotificationTap(message.data.cast());
    }
    return Future.value(null);
  }

  static Future<void> showNotification(
      String title, String body, RemoteMessage remoteMessage) async {
    // await FlutterRingtonePlayer.playNotification(
    //   volume: 0.1,
    //   looping: false,
    // );
    showOverlayNotification(
      (context) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              handleNotificationTap(remoteMessage.data.cast());
            },
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            body,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 3000),
    );
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      Logger().e("Fcm Token");
      print(token);
      if (token != null) {
        MySharedPref.setFcmToken(token);
        _sendFcmTokenToServer(token);

        if (Platform.isIOS) {
          await getDevicePushTokenVoIP();
        }
        // GET VOIP TOKEN
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  static Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print('🎁------- VOIP TOKEN -----🎁');
    print(devicePushTokenVoIP);
    await MySharedPref.setVoIPToken(devicePushTokenVoIP);
    await _sendVoIPTokenToServer(devicePushTokenVoIP);
  }

  static _sendVoIPTokenToServer(String token) async {
    final AuthCtrl = Get.find<AuthController>();

    // TODO SEND FCM TOKEN TO SERVER
    try {
      final myAuth = AuthCtrl.chatUser;
      if (myAuth == null) return;

      await FirebaseFirestore.instance
          .collection(DatabaseConfig.USER_COLLECTION)
          .doc(myAuth.id)
          .update({"metadata.voip_token": token});
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  static _sendFcmTokenToServer(String token) {
    final AuthCtrl = Get.find<AuthController>();
    var token = MySharedPref.getFcmToken();
    // TODO SEND FCM TOKEN TO SERVER
    try {
      final myAuth = AuthCtrl.chatUser;
      if (myAuth == null) return;

      FirebaseFirestore.instance
          .collection(DatabaseConfig.USER_COLLECTION)
          .doc(myAuth.id)
          .update({"metadata.fcm_token": token});
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  /****************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.10.16
   * @Desc: Send Call Request Notification
   */
  static Future sendCallRequestNotification({
    required String fcmToken,
    required String title,
    required String message,
    required Map<String, dynamic> payload,
    String? largeIcon,
  }) async {
    print("payload: $payload");
    try {
      var client = http.Client();
      try {
        var response =
            await client.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "key=$FCM_SERVER_KEY",
                },
                body: json.encode(
                  {
                    "to": fcmToken,
                    // "mutable_content": true,
                    "content_available": true,
                    "priority": "high",
                    "notification": {
                      "badge": 1,
                      "title": title,
                      "body": message,
                    },
                    "data": {
                      "type": MessageType.CALL,
                      "content": {"largeIcon": largeIcon, "payload": payload},
                    },
                    "android": {
                      "priority": "high",
                    },

                    "apns": {
                      "headers": {
                        "apns-push-type": "voip",
                        "apns-topic": "com.criptyc.transfer.voip"
                      },
                      "payload": {
                        "aps": {"contentAvailable": 1},
                        "customKey": "customValue"
                      }
                    }
                  },
                ));
      } finally {
        client.close();
      }
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  /***************************************
   * @Desc: Send Push Notification to user
   */
  static sendPushNotification(
      {required String fcmToken,
      required String title,
      required String message,
      MessageType? messageType,
      String? largeIcon,
      String? bigImg}) async {
    try {
      var client = http.Client();
      try {
        var response =
            await client.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "key=$FCM_SERVER_KEY",
                },
                body: json.encode(
                  {
                    "to": fcmToken,
                    "mutable_content": true,
                    "priority": "high",
                    "notification": {
                      "badge": 50,
                      "title": title,
                      "body": message,
                    },
                    "data": {
                      "type": messageType ?? MessageType.MESSAGE,
                      "content": {
                        "id": 1,
                        "badge": 50,
                        "channelKey": messageType == MessageType.CALL
                            ? NotificationChannels.callChannelKey
                            : messageType == MessageType.MESSAGE
                                ? NotificationChannels.chatChannelKey
                                : NotificationChannels.generalChannelKey,
                        "displayOnForeground": true,
                        "notificationLayout": "BigPicture",
                        "largeIcon": largeIcon,
                        "bigPicture": bigImg,
                        "showWhen": true,
                        "autoDismissible": true,
                        "privacy": "Private",
                        "payload": {"secret": "Awesome Notifications Rocks!"}
                      },
                      "actionButtons": [
                        {
                          "key": "REDIRECT",
                          "label": "Redirect",
                          "autoDismissible": true
                        },
                        {
                          "key": "DISMISS",
                          "label": "Dismiss",
                          "actionType": "DismissAction",
                          "isDangerousOption": true,
                          "autoDismissible": true
                        }
                      ]
                    }
                  },
                ));
      } finally {
        client.close();
      }
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    Logger().d('😎 FOREGOUND NOTIFICATION');
    handleNotification(message);
  }

  static void handleNotification(
    RemoteMessage message,
  ) async {
    Logger().i('✨----- FCM  Handler ------> ${jsonEncode(message.data)}');

    String type = message.data['type'];
    Logger().d(type);
    Map<String, dynamic>? data =
        (message.data != null && message.data['content'] != null)
            ? jsonDecode(message.data['content'])
            : null;
    switch (type) {
      case '${MessageType.CALL}':
        CallKitHelper.showCallRequestNotification(
          id: message.hashCode,
          title: message.notification?.title ?? 'Title',
          body: message.notification?.body ?? 'Body',
          payload: message.data
              .cast(), // pass payload to the notification card so you can use it (when user click on notification)
          largeIcon: data?['largeIcon'],
        );
        break;

      case '${MessageType.MESSAGE}':
        showNotification(message.notification?.title ?? 'Title',
            message.notification?.body ?? "", message);

        break;

      default:
        showNotification(message.notification?.title ?? 'Title',
            message.notification?.body ?? "", message);
        break;
    }
  }

  static Future<void> handleNotificationTap(
      Map<String, String?>? payload) async {
    if (payload != null) {
      String type = payload['type']!;
      switch (type) {
        case MessageType.CALL:
          if (payload['content'] != null) {
            final data = jsonDecode(payload['content']!);
            Logger().d(data);
            Get.toNamed(Routes.INCOMING_CALL, arguments: {'data': data});
          }
          break;
        case MessageType.CHAT_REQUEST:
          final authCtrl = Get.find<AuthController>();
          if (authCtrl != null && authCtrl.chatUser != null) {
            Get.toNamed(Routes.CHAT_LIST);
          }
          break;
        case MessageType.MESSAGE:
          final authCtrl = Get.find<AuthController>();
          if (authCtrl != null && authCtrl.chatUser != null) {
            Get.toNamed(Routes.CHAT_LIST);
          }
          break;

        default:
      }
    }
  }
}

class MessageType {
  static const String MESSAGE = "MESSAGE";
  static const String CALL = "CALL";
  static const String CHAT_REQUEST = "CHAT_REQUEST";
  static const String OTHER = "OTHER";
}

class NotificationChannels {
  // chat channel (for messages only)
  static String get chatChannelKey => "chat_channel";
  static String get chatChannelName => "Chat channel";
  static String get chatGroupKey => "chat group key";
  static String get chatChannelGroupKey => "chat_channel_group";
  static String get chatChannelGroupName => "Chat notifications channels";
  static String get chatChannelDescription => "Chat notifications channels";

  // general channel (for all other notifications)
  static String get generalChannelKey => "general_channel";
  static String get generalGroupKey => "general group key";
  static String get generalChannelGroupKey => "general_channel_group";
  static String get generalChannelGroupName => "general notifications channel";
  static String get generalChannelName => "general notifications channels";
  static String get generalChannelDescription =>
      "Notification channel for general notifications";

  // Call Notification Channel (for Call only)
  static String get callChannelKey => "call_channel";
  static String get callChannelName => "Call Channel";
  static String get callGroupKey => "call_ group_key";
  static String get callChannelGroupKey => "call_channel_group";
  static String get callChannelGroupName => "Call Notifications Channels";
  static String get callChannelDescription => "Call Notifications Channels";
}
