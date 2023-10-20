import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(User user) =>
    '${user.firstName ?? 'Criptacy'} ${user.lastName ?? 'User'}'.trim();

getUserStatus(String status) {
  switch (status) {
    case 'online':
      return UserStatus.ONLINE;
    case 'offline':
      return UserStatus.OFFLINE;

    case 'away':
      return UserStatus.AWAY;

    default:
  }
}

User? getOtherUser({required Room room}) {
  final authCtrl = Get.find<AuthController>();
  User? otherUser;
  if (room.type == RoomType.direct) {
    try {
      otherUser = room.users.firstWhere(
        (u) => u.id != authCtrl.chatUser!.id,
      );
    } catch (e) {
      Logger().e(e);
    }
  }
  return otherUser;
}

User? getCurrentUser({required Room room}) {
  final authCtrl = Get.find<AuthController>();
  return authCtrl.chatUser;
  // final _user = FirebaseAuth.instance.currentUser;
  // User? otherUser;
  // if (room.type == RoomType.direct) {
  //   try {
  //     otherUser = room.users.firstWhere(
  //       (u) => u.id == _user!.uid,
  //     );
  //   } catch (e) {
  //     Logger().e(e);
  //   }
  // }
  // return otherUser;
}

getLastMessage({required Room room}) {
  // Last Message
  String lastMessage =
      room.metadata != null ? room.metadata!['lastMessage'] ?? "" : "";
  return lastMessage;
}

getUnreadCount({required Room room}) {
  // final _user = FirebaseAuth.instance.currentUser;
  final authCtrl = Get.find<AuthController>();
  User? _user = authCtrl.chatUser;
  // Unread Message Count
  return room.metadata != null
      ? room.metadata!['messageCount'] != null
          ? room.metadata![_user!.id] != null
              ? room.metadata!['messageCount'] - room.metadata![_user.id]
              : room.metadata!['messageCount']
          : 0
      : 0;
}

Room? getFeedRoom({required List<Room> rooms}) {
  Room? _feedRoom;
  for (Room room in rooms) {
    if (room.type == RoomType.group &&
        room.name == DatabaseConfig.FEED_ROOM_NAME) {
      _feedRoom = room;
    }
  }
  return _feedRoom;
}

Future<User?> getUserWithID(String id) async {
  final userRef =
      FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);
  return await userRef.doc(id).get().then((doc) async {
    if (doc.exists) {
      final data = doc.data();
      data!['id'] = id;

      User _user = User.fromJson(data);
      return _user;
    } else {
      return null;
    }
  });
}
