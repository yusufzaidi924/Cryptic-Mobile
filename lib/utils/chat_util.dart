import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) =>
    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

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

types.User? getOtherUser({required types.Room room}) {
  final _user = FirebaseAuth.instance.currentUser;
  types.User? otherUser;
  if (room.type == types.RoomType.direct) {
    try {
      otherUser = room.users.firstWhere(
        (u) => u.id != _user!.uid,
      );
    } catch (e) {
      Logger().e(e);
    }
  }
  return otherUser;
}

types.User? getCurrentUser({required types.Room room}) {
  final _user = FirebaseAuth.instance.currentUser;
  types.User? otherUser;
  if (room.type == types.RoomType.direct) {
    try {
      otherUser = room.users.firstWhere(
        (u) => u.id == _user!.uid,
      );
    } catch (e) {
      Logger().e(e);
    }
  }
  return otherUser;
}

getLastMessage({required types.Room room}) {
  // Last Message
  String lastMessage =
      room.metadata != null ? room.metadata!['lastMessage'] ?? "" : "";
  return lastMessage;
}

getUnreadCount({required types.Room room}) {
  final _user = FirebaseAuth.instance.currentUser;
  // Unread Message Count
  return room.metadata != null
      ? room.metadata!['messageCount'] != null
          ? room.metadata![_user!.uid] != null
              ? room.metadata!['messageCount'] - room.metadata![_user.uid]
              : room.metadata!['messageCount']
          : 0
      : 0;
}

types.Room? getFeedRoom({required List<types.Room> rooms}) {
  types.Room? _feedRoom;
  for (types.Room room in rooms) {
    if (room.type == types.RoomType.group &&
        room.name == DatabaseConfig.FEED_ROOM_NAME) {
      _feedRoom = room;
    }
  }
  return _feedRoom;
}

Future<types.User?> getUserWithID(String id) async {
  final userRef =
      FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);
  return await userRef.doc(id).get().then((doc) async {
    if (doc.exists) {
      final data = doc.data();
      data!['id'] = id;

      types.User _user = types.User.fromJson(data);
      return _user;
    } else {
      return null;
    }
  });
}
