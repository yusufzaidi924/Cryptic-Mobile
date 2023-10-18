import 'package:edmonscan/app/data/models/RequestChatModel.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatListController extends GetxController {
  //TODO: Implement ChatListController
  final PageController pageController = PageController();

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

  @override
  void onInit() {
    super.onInit();
    roomListInit();
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
