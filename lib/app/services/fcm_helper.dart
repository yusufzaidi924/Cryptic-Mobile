import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/data/local/my_shared_pref.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/services/awesome_notifications_helper.dart';
import 'package:edmonscan/config/plugin/firebase_options1.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class FcmHelper {
  static const String FCM_SERVER_KEY =
      "AAAAsT8Xmng:APA91bGsG6TTGfXElpWgJs7fXooR-wfekXC5zjNgbKRJLzSJULO_aAz8GZ7loWWc3U5LFPe_3-mIWjt_G5t4UpTKJfQRIK1jxbAD_90xvf3TSw2Qn0XWrjmC7ruRLpwC8NAzeOWaZJPS";

  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
        name: "FCM",
        // TODO: uncomment this line if you connected to firebase via cli
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (error) {
      // if you are connected to firebase and still get error
      // check the todo up in the function else ignore the error
      // or stop fcm service from main.dart class
      Logger().e(error);
    }
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
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
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
  static sendCallRequestNotification({
    required String fcmToken,
    required String title,
    required String message,
    required Map<String, dynamic> payload,
    String? largeIcon,
  }) async {
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
                      "badge": 1,
                      "title": title,
                      "body": message,
                    },
                    "data": {
                      "type": MessageType.CALL,
                      "content": {"largeIcon": largeIcon, "payload": payload},
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
                        "channelKey": "alerts",
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

  /*********************************************
   * @Desc: Send Push Notification to Multi User
   */

  ///handle fcm notification when app is closed/terminated
  /// if you are wondering about this annotation read the following
  /// https://stackoverflow.com/a/67083337
  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    // Map<String, dynamic>? data =
    //     (message.data != null && message.data['content'] != null)
    //         ? jsonDecode(message.data['content'])
    //         : null;
    // AwesomeNotificationsHelper.showNotification(
    //   id: 1,
    //   title: message.notification?.title ?? 'Title',
    //   body: message.notification?.body ?? 'Body',
    //   payload: message.data
    //       .cast(), // pass payload to the notification card so you can use it (when user click on notification)
    //   largeIcon: data?['largeIcon'],

    //   notificationLayout: NotificationLayout.Messaging,
    // );
    Logger().d('😜 BACKGROUND NOTIFICATION');
    handleNotification(message);
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    // handleNotification(message);
    // Logger().d(message.notification?.body);

    // Map<String, dynamic>? data =
    //     (message.data != null && message.data['content'] != null)
    //         ? jsonDecode(message.data['content'])
    //         : null;

    // AwesomeNotificationsHelper.showNotification(
    //   id: 1,
    //   title: message.notification?.title ?? 'Title',
    //   body: message.notification?.body ?? 'Body',
    //   payload: message.data
    //       .cast(), // pass payload to the notification card so you can use it (when user click on notification)
    //   largeIcon: data?['largeIcon'],
    //   notificationLayout: NotificationLayout.BigPicture,
    //   actionButtons: [
    //     NotificationActionButton(
    //         key: "REDIRECT", label: "Redirect", autoDismissible: true),
    //     NotificationActionButton(
    //         key: "DISMISS",
    //         label: "Dismiss",
    //         actionType: ActionType.DismissAction,
    //         isDangerousOption: true,
    //         autoDismissible: true),
    //   ],
    // );
    Logger().d('😎 FOREGOUND NOTIFICATION');
    handleNotification(message);
  }

  static void handleNotification(
    RemoteMessage message,
  ) async {
    Logger().i('✨----- FCM  Handler ------> ${jsonEncode(message.data)}');

    String type = message.data['type'];
    Map<String, dynamic>? data =
        (message.data != null && message.data['content'] != null)
            ? jsonDecode(message.data['content'])
            : null;
    switch (type) {
      case '${MessageType.CALL}':
        AwesomeNotificationsHelper.showCallRequestNotification(
          id: 2,
          title: message.notification?.title ?? 'Title',
          body: message.notification?.body ?? 'Body',
          payload: message.data
              .cast(), // pass payload to the notification card so you can use it (when user click on notification)
          largeIcon: data?['largeIcon'],
        );
        break;

      case '${MessageType.MESSAGE}':
        AwesomeNotificationsHelper.showNotification(
          id: 1,
          title: message.notification?.title ?? 'Title',
          body: message.notification?.body ?? 'Body',
          payload: message.data
              .cast(), // pass payload to the notification card so you can use it (when user click on notification)
          largeIcon: data?['largeIcon'],
          summary: '',

          notificationLayout: NotificationLayout.Messaging,
        );
        break;

      default:
        AwesomeNotificationsHelper.showNotification(
          id: 1,
          title: message.notification?.title ?? 'Title',
          body: message.notification?.body ?? 'Body',
          payload: message.data
              .cast(), // pass payload to the notification card so you can use it (when user click on notification)
          largeIcon: data?['largeIcon'],
          summary: '',
          notificationLayout: NotificationLayout.BigPicture,
        );
        break;
    }
  }
}

class MessageType {
  static const String MESSAGE = "MESSAGE";
  static const String CALL = "CALL";
  static const String CHAT_REQUEST = "CHAT_REQUEST";
  static const String OTHER = "OTHER";
}
