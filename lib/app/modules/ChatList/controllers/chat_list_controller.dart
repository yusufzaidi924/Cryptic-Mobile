import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  //TODO: Implement ChatListController

  final count = 0.obs;
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  onUpdateTabIndex(int index) {
    _tabIndex.value = index;
    update();
  }

  final _rooms = Rx<List<Room>>([]);
  List<Room> get rooms => _rooms.value;

  /**********************************
   * ROOM LIST INIT
   */
  roomListInit() {
    try {
      _rooms
          .bindStream(FirebaseChatCore.instance.rooms(orderByUpdatedAt: true));
      _rooms.listen((e) {
        update();
      });
    } catch (e) {
      print("$e");
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
