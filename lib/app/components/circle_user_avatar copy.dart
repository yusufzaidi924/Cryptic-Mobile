// import 'package:edmonscan/utils/chat_util.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:logger/logger.dart';

Widget CircleUserAvatar({
  double radius = 30,
  types.User? user,
  bool visibleStatus = true,
  types.Room? room,
}) {
  UserStatus status = UserStatus.OFFLINE;
  Color backgColor = Colors.grey;
  String? img;
  String? name;
  bool isPrivate = false;
  if (user != null) {
    // User Status
    if (user.metadata != null) {
      if (user.metadata!['status'] != null) {
        status = getUserStatus(user.metadata!['status']);
      }
      isPrivate = user.metadata![PrivacySettingKey.COLLECTION]
              ?[PrivacySettingKey.PRIVATE_ACCOUNT] ??
          false;
      // Logger().e("Is Private", isPrivate);
    }

    // Image
    img = "${Network.BASE_URL}${user.imageUrl}";

    // Name
    name = user.firstName;

    if (img == null) {
      // Color
      backgColor = getUserAvatarNameColor(user);
    }
  }

  int unreadCount = room != null ? getUnreadCount(room: room) : 0;

  return InkWell(
    onTap: () {
      Logger().i(
          "===================== Tapped Circle Avatar !!!!=========================");
      if (user != null &&
          user.metadata!['blockList'] != null &&
          user.metadata!['blockList']
              .contains(FirebaseAuth.instance.currentUser!.uid)) {
        // ErrorMsg.BLOCKED_MESSAGE;
        Get.snackbar(
          'Blocked User',
          'You cannot view this profile as they have blocked you.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Get.to(ProfileView(
        //   user: user!,
        //   lastMessage: room != null ? getLastMessage(room: room) : "",
        // ));
      }
    },
    child: Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgColor,
          backgroundImage: img != null ? NetworkImage(img) : null,
          child: img != null
              ? Container()
              : Text(
                  name != null ? name[0].toUpperCase() : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Visibility(
            visible: visibleStatus,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 8,
              child: CircleAvatar(
                backgroundColor: status == UserStatus.ONLINE
                    ? Color(0xff6AFF64)
                    : status == UserStatus.OFFLINE
                        ? Colors.yellow
                        : Colors.grey,
                radius: 6,
              ),
            ),
          ),
        ),
        Positioned(
          top: -3,
          right: 0,
          child: Visibility(
            visible: unreadCount > 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
