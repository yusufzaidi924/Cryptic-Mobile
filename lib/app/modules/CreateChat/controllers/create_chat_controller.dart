import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CreateChatController extends GetxController {
  //TODO: Implement CreateChatController

  final count = 0.obs;
  final authCtrl = Get.find<AuthController>();
  final _users = Rx<List<User>>([]);
  get users => _users.value;
  ///////////////// USERS_20_LIST_GET ////////////////
  user20ListInit() async {
    Logger().i('------------- USER 20 INIT ----------------');
    // final authCtrl = Get.put<AuthController>();
    AuthController authCtrl = Get.put(AuthController());

    Logger().i(authCtrl.chatUser!.id);
    if (authCtrl.chatUser == null) return _users.bindStream(Stream.empty());

    try {
      final streamUsers = MyChatCore.instance.users();
      // await FirebaseChatCore.instance.users();
      _users.bindStream(streamUsers);

      _users.listen((e) {
        // print("$e");
        Logger().i(e);
        update();
      });
    } catch (e) {
      print("$e");
      Logger().e('$e');
    }
  }

  onTapChat(User otherUser) async {
    EasyLoading.show();
    bool exist = await MyChatCore.instance.checkRoomExist(otherUser);
    Logger().d(exist);

    if (exist) {
      EasyLoading.dismiss();

      await onCreateChatRoom(otherUser);
    } else {
      // Check Request Exist
      if (await checkRequestExist(otherUser)) {
        EasyLoading.dismiss();

        Get.defaultDialog(
          title: 'Alert',
          middleText: 'You have already sent a chat request to this user!',
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        );
      } else {
        // Send Chat Request
        await sendChatRequest(otherUser);

        EasyLoading.dismiss();
      }
    }
  }

  /*************************
   * Create Chat Room
   */
  onCreateChatRoom(User otherUser) async {
    Logger().i(otherUser.id);
    try {
      // EasyLoading.show(status: "Loading...");
      EasyLoading.show();
      // final authCtrl = Get.find<AuthController>();
      // final _user = authCtrl.chatUser;
      final room = await MyChatCore.instance.createRoom(otherUser, metadata: {
        "messageCount": 0,
        otherUser.id: 0,
        authCtrl.chatUser!.id: 0,
        "lastMessage": "",
      });

      EasyLoading.dismiss();

      // Go To Chat Room Page
      Get.toNamed(Routes.CHAT_ROOM, arguments: {
        'room': room,
      });
    } catch (e) {
      Logger().e('$e');
      EasyLoading.dismiss();
    }
  }

  /************************************
   * Check Call Request
   */
  Future<bool> checkRequestExist(User user) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(DatabaseConfig.CHAT_REQUEST_COLLECTION)
        .where('to', isEqualTo: user.id.toString())
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Room exists with the specified user ID
      final request = snapshot.docs.first;
      print('Request ${request.id} exists');

      return true;
    } else {
      // Room does not exist with the specified user ID
      print('Request does not exist');
      return false;
    }
  }

  /************************************
   * Send CHAT Request
   */
  Future<void> sendChatRequest(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseConfig.CHAT_REQUEST_COLLECTION)
          .add({
        'from': authCtrl.authUser!.id.toString(),
        'to': user.id.toString(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // SEND NOTIFICATION
      await sendRequestNotification(user);

      CustomSnackBar.showCustomSnackBar(
          title: "SUCCESS", message: "You sent chat request successfully!");
    } catch (e) {
      Logger().e(e);
      CustomSnackBar.showCustomErrorSnackBar(
          title: "SUCCESS", message: e.toString());
    }
  }

  /////////////////////////// CONTACT LIST ///////////////////////
  /*****************************
   * Get Contact List
   */
  final _isContactGrant = false.obs;
  bool get isContactGrant => _isContactGrant.value;
  final _contacts = Rx<List<Contact>>([]);
  List<Contact> get contacts => _contacts.value;

  Future getContactList() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      _isContactGrant.value = false;
      update();
    } else {
      _contacts.value = await FlutterContacts.getContacts(
          withPhoto: true, withThumbnail: false, withProperties: true);
      _isContactGrant.value = true;
      update();
    }
  }

  /****************************************
   * Create Chat With Contact
   */
  Future<void> onCreateContactChat(String phone) async {
    EasyLoading.show();
    try {
      String phoneNumber = "+" + Regex.removeSpecialChars(phone);
      Logger().d(phoneNumber);
      User? user = await checkUserWithPhone(phone);
      EasyLoading.dismiss();

      if (user != null) {
        await onTapChat(user);
      } else {
        EasyLoading.show();

        // Send Invite SMS
        final res = await UserRepository.sendInviteSMS({
          'phone': phoneNumber,
          'fromName': getUserName(authCtrl.chatUser!),
          'fromPhone': authCtrl.authUser!.phone,
        });
        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS",
              message:
                  "Chat invitation SMS is sent to ${phoneNumber} successfully!");
        } else {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomErrorSnackBar(
              title: "ERROR",
              message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  /*************************************
   * Check user Exist with phone number
   */
  Future<User?> checkUserWithPhone(String phone) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(DatabaseConfig.CHAT_REQUEST_COLLECTION)
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final user = snapshot.docs.first;
      print('User ${user.id} exists');
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      Logger().d(data);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  /*********************************
   * Send Chat Request Notification
   */
  sendRequestNotification(User toUser) async {
    if (toUser != null &&
        toUser.metadata != null &&
        toUser.metadata!['fcm_token'] != null) {
      String fcmToken = toUser.metadata!['fcm_token'].toString();
      String username = getUserName(authCtrl.chatUser!);
      FcmHelper.sendPushNotification(
          fcmToken: fcmToken,
          title: "Chat Request",
          message: '${username} sent you chat request');
    }
  }

  @override
  void onInit() {
    super.onInit();
    user20ListInit();
    getContactList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
