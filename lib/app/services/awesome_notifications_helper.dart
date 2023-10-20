import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'fcm_helper.dart';

class AwesomeNotificationsHelper {
  // prevent making instance
  AwesomeNotificationsHelper._();

  // Notification lib

  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  /// initialize local notifications service, create channels and groups
  /// setup notifications button actions handlers
  static init() async {
    // initialize local notifications
    await _initNotification();

    // request permission to show notifications
    awesomeNotifications.requestPermissionToSendNotifications();

    // list when user click on notifications
    listenToActionButtons();
  }

  /// when user click on notification or click on button on the notification
  static listenToActionButtons() {
    // Only after at least the action method is set, the notification events are delivered
    awesomeNotifications.setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  ///init notifications channels
  static _initNotification() async {
    await awesomeNotifications.initialize(
        null, // null mean it will show app icon on the notification (status bar)
        [
          NotificationChannel(
            channelGroupKey: NotificationChannels.generalChannelGroupKey,
            channelKey: NotificationChannels.generalChannelKey,
            channelName: NotificationChannels.generalChannelName,
            groupKey: NotificationChannels.generalGroupKey,
            channelDescription: NotificationChannels.generalChannelDescription,
            defaultColor: LightThemeColors.primaryColor,
            ledColor: Colors.white,
            channelShowBadge: true,
            playSound: true,
            importance: NotificationImportance.Max,
          ),
          NotificationChannel(
              channelGroupKey: NotificationChannels.chatChannelGroupKey,
              channelKey: NotificationChannels.chatChannelKey,
              channelName: NotificationChannels.chatChannelName,
              groupKey: NotificationChannels.chatGroupKey,
              channelDescription: NotificationChannels.chatChannelDescription,
              defaultColor: LightThemeColors.primaryColor,
              ledColor: Colors.white,
              channelShowBadge: true,
              playSound: true,
              importance: NotificationImportance.Max),
          NotificationChannel(
              channelGroupKey: NotificationChannels.callChannelGroupKey,
              channelKey: NotificationChannels.callChannelKey,
              channelName: NotificationChannels.callChannelName,
              groupKey: NotificationChannels.callGroupKey,
              channelDescription: NotificationChannels.callChannelDescription,
              defaultColor: LightThemeColors.primaryColor,
              ledColor: Colors.white,
              channelShowBadge: false,
              defaultRingtoneType: DefaultRingtoneType.Ringtone,
              playSound: true,
              importance: NotificationImportance.Max),
        ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: NotificationChannels.generalChannelGroupKey,
        channelGroupName: NotificationChannels.generalChannelGroupName,
      ),
      NotificationChannelGroup(
        channelGroupKey: NotificationChannels.chatChannelGroupKey,
        channelGroupName: NotificationChannels.chatChannelGroupName,
      ),
      NotificationChannelGroup(
        channelGroupKey: NotificationChannels.callChannelGroupKey,
        channelGroupName: NotificationChannels.callChannelGroupName,
      )
    ]);
  }

  //display notification for user with sound
  static showNotification(
      {required String title,
      required String body,
      required int id,
      String? channelKey,
      String? groupKey,
      NotificationLayout? notificationLayout,
      String? summary,
      List<NotificationActionButton>? actionButtons,
      Map<String, String>? payload,
      String? largeIcon}) async {
    awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: id,
            title: title,
            body: body,
            groupKey: groupKey ?? NotificationChannels.generalGroupKey,
            channelKey: channelKey ?? NotificationChannels.generalChannelKey,
            showWhen:
                true, // Hide/show the time elapsed since notification was displayed
            payload:
                payload, // data of the notification (it will be used when user clicks on notification)
            notificationLayout: notificationLayout ??
                NotificationLayout
                    .BigPicture, // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
            autoDismissible:
                true, // dismiss notification when user clicks on it
            summary:
                summary, // for ex: New message (it will be shown on status bar before notificaiton shows up)
            largeIcon:
                largeIcon, // image of sender for ex (when someone send you message his image will be shown)
          ),
          actionButtons: actionButtons,
        );
      }
    });
  }

  //Display Notification for user with sound
  static showCallRequestNotification(
      {required String title,
      required String body,
      required int id,
      // String? summary,
      // List<NotificationActionButton>? actionButtons,
      Map<String, String>? payload,
      String? largeIcon}) async {
    awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: id,
            title: title,
            body: body,
            groupKey: NotificationChannels.callGroupKey,
            channelKey: NotificationChannels.callChannelKey,
            showWhen:
                true, // Hide/show the time elapsed since notification was displayed
            payload:
                payload, // data of the notification (it will be used when user clicks on notification)
            notificationLayout: NotificationLayout
                .BigPicture, // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
            autoDismissible:
                true, // dismiss notification when user clicks on it
            // summary:
            //     summary, // for ex: New message (it will be shown on status bar before notificaiton shows up)
            largeIcon:
                'https://placebear.com/g/200/300', // image of sender for ex (when someone send you message his image will be shown)
          ),
          // actionButtons: actionButtons,
        );
      }
    });
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    AwesomeNotificationsHelper.awesomeNotifications
        .decrementGlobalBadgeCounter();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    Map<String, String?>? payload = receivedAction.payload;
    // TODO handle clicking on notification
    // example
    AwesomeNotificationsHelper.awesomeNotifications
        .decrementGlobalBadgeCounter();

    Logger().i('👍👍👍 ------ TAP NOTIFICATION ----- 👍👍👍');
    Logger().d(payload);

    handleNotificationTap(payload);

    // Get.offAll(() => const SocialInboxView());

    // if (payload?['sender'] == 'stream.chat') {
    //   HomePage.index = TabItem.home;

    //   MainScreen.targetChannel = payload!['channel_id']!;
    //   MainScreen.targetChannelType = payload['channel_type']!;

    //   // if (payload['background'] == null) {
    //   try {
    //     final context = MyApp.navigatorKey.currentContext;
    //     final client = StreamChat.of(context!).client;
    //     final channel = await client.queryChannel(MainScreen.targetChannelType,
    //         channelId: MainScreen.targetChannel);

    //     AppProviderPage.of(context).selectedRoom =
    //         channel.channel!.extraData['room'].toString();

    //     try {
    //       final currentChannel = StreamChannel.of(context).channel;
    //       if (currentChannel.cid != payload['cid']) {
    //         throw 'Navigate';
    //       }
    //     } catch (e) {
    //       MyApp.navigatorKey.currentState
    //           ?.push(MaterialPageRoute(builder: (context) => const HomePage()));
    //     }
    //   } catch (e) {}
    //   // }
    // } else {
    //   HomePage.index = TabItem.notification;
    //   NotificationScreen.defaultIndex = payload?['type'] == 'admin' ? 0 : 1;

    //   try {
    //     final context = MyApp.navigatorKey.currentContext;
    //     final client = StreamChat.of(context!).client;

    //     MyApp.navigatorKey.currentState
    //         ?.push(MaterialPageRoute(builder: (context) => const HomePage()));
    //   } catch (e) {}
    // }

    // if (payload?['background'] == null) {
    // }
    // MyApp.navigatorKey.currentState?.pushNamed(TabNavigatorRoutes.notification);
    // Navig
    // HomePage.navigatorKeys[HomePage.index]?.currentState
    //     ?.pushNamed(TabNavigatorRoutes.home);
    // navigator?.pushNamed(TabNavigatorRoutes.home);
    // TabNavigator.navigatorKey.currentState?.pushNamed(TabNavigatorRoutes.home);
    // Navigator.pushNamed(Get.context!, TabNavigatorRoutes.home);
    // Get.key.currentState?.pushNamed(TabNavigatorRoutes.home);
  }
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

/*********************************
 * Handle Notification after Tap it
 */
Future<void> handleNotificationTap(Map<String, String?>? payload) async {
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
