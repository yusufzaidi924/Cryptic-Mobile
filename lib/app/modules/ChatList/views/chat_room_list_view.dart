import 'package:edmonscan/app/components/circle_user_avatar%20copy.dart';
import 'package:edmonscan/app/modules/ChatList/controllers/chat_list_controller.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class ChatRoomListView extends GetView<ChatListController> {
  const ChatRoomListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: (controller) {
      return controller.rooms.length == 0
          ? const Center(
              child: Text("No Data"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: controller.rooms.length,
              itemBuilder: (context, index) {
                // Room room = controller.rooms[index];
                // if (controller.rooms == null) {
                //   return Container(
                //     child: const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   );
                // }
                if (controller.rooms.length == 0) {
                  return const Text("No Data");
                }
                return _roomRow(
                    controller.rooms[index], controller.searchTextCtrl.text);
                // return Container();
              },
            );
    });
  }

  Widget _roomRow(Room room, String search) {
    var color = Colors.transparent;
    User? otherUser = getOtherUser(room: room);
    User? _user = getCurrentUser(room: room);
    String lastMessage = getLastMessage(room: room);
    int unreadCount = getUnreadCount(room: room);

    // bool isNSFWAllowed = _user != null
    //     ? _user.metadata != null
    //         ? _user.metadata![PrivacySettingKey.COLLECTION] != null
    //             ? _user.metadata![PrivacySettingKey.COLLECTION]
    //                         [PrivacySettingKey.ALLOW_NSFW_CONTENTS] !=
    //                     null
    //                 ? _user.metadata![PrivacySettingKey.COLLECTION]
    //                     [PrivacySettingKey.ALLOW_NSFW_CONTENTS]
    //                 : false
    //             : false
    //         : false
    //     : false;
    // bool isNSFWMsg = TextFilter.checkMessage(lastMessage);

    return ("${otherUser!.firstName} ${otherUser.lastName}".contains(search))
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                onTap: () => controller.onTapRoomEvent(room),
                // onLongPress: () => Get.to(ProfileView(
                //   user: otherUser,
                //   lastMessage: !isNSFWAllowed && isNSFWMsg
                //       ? TextFilter.cleanMessage(lastMessage)
                //       : lastMessage,
                // )),
                leading: CircleUserAvatar(user: otherUser),
                title: Text(
                  "${otherUser.firstName ?? 'Criptacy'} ${otherUser.lastName ?? 'User'}",
                  style: TextStyle(
                    color: Color(0xFF421EB7),
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    lastMessage,
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeAgoSinceDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            room.updatedAt ?? 0),
                        numericDates: true,
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: unreadCount > 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                child: const Divider(
                  height: 3,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
              )
            ],
          )
        : const SizedBox();
  }
}
