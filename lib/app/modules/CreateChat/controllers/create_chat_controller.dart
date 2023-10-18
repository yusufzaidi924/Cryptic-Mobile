import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
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

  @override
  void onInit() {
    super.onInit();
    user20ListInit();
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
