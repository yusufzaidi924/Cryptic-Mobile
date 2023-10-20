import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/RequestChatModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatListController extends GetxController {
  //TODO: Implement ChatListController
  final PageController pageController = PageController();
  final authCtrl = Get.find<AuthController>();
  /***********************
   * onPageChanged
   */
  onPageChanged(int index) {
    _tabIndex.value = index;
    update();
  }

  final count = 0.obs;
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  onUpdateTabIndex(int index) {
    _tabIndex.value = index;
    pageController.animateToPage(tabIndex,
        duration: Duration(milliseconds: 100), curve: Curves.linear);
    searchTextCtrl.text = "";
    update();
  }

  final _rooms = Rx<List<Room>>([]);
  List<Room> get rooms => _rooms.value;

  /**********************************
   * ROOM LIST INIT
   */
  roomListInit() {
    Logger().i("-------------ROOM LIST INIT ------------");
    try {
      final streamRooms = MyChatCore.instance.rooms(orderByUpdatedAt: true);
      _rooms.bindStream(streamRooms);
      _rooms.listen((e) {
        Logger().i('$e');
        update();
      });
      update();
    } catch (e) {
      print("$e");
    }
  }

  final _requests = Rx<List<RequestChatModel>>([]);
  List<RequestChatModel> get requests => _requests.value;

  /**********************************
   * ROOM LIST INIT
   */
  chatRequestListInit() {
    Logger().i("-------------CHAT REQUEST LIST INIT ------------");
    try {
      final streamRequests =
          MyChatCore.instance.requests(orderByCreatedAt: true);
      _requests.bindStream(streamRequests);
      _requests.listen((e) {
        Logger().i('$e');
        update();
      });
      update();
    } catch (e) {
      print("$e");
    }
  }

  /*********************************
   * onTapChatRequest
   */
  onTapChatRequest(RequestChatModel request) async {}

  /**************************************
   * On Click Floating Button to Add Chat
   */
  onAddChat() {
    Get.toNamed(Routes.CREATE_CHAT);
  }

  /*****************************************
   * OnTapChatRoom
   */
  onTapRoomEvent(Room room) {
    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      'room': room,
    });
  }

  final searchTextCtrl = TextEditingController();
  final _isOpenSearch = false.obs;
  bool get isOpenSearch => _isOpenSearch.value;
  updateSearchStatus(bool status) {
    _isOpenSearch.value = status;
    update();
  }

  onSearchUpdate(String? value) {
    if (value != null) {
      searchTextCtrl.text = value;
      update();
    }
  }

  /*******************************
   * @Auth: genius0813@gmail.com
   * @Date: 2022.10.19
   * @Desc: Accept Chat Request
   */
  onAcceptRequest(RequestChatModel request) async {
    User? otherUser = request.fromUser;
    if (otherUser == null) return;
    await onCreateChatRoom(otherUser);
    await deleteRequest(request);
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

  /**********************************
   * onRejectRequest
   */
  onRejectRequest(RequestChatModel request) async {
    try {
      EasyLoading.show();
      await deleteRequest(request);
      EasyLoading.dismiss();
    } catch (e) {
      Logger().e(e);
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  Future<void> deleteRequest(RequestChatModel request) async {
    final requestRef = FirebaseFirestore.instance
        .collection(DatabaseConfig.CHAT_REQUEST_COLLECTION)
        .doc(request.id);
    await requestRef.delete();
  }

  @override
  void onInit() {
    super.onInit();
    roomListInit();
    chatRequestListInit();
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
