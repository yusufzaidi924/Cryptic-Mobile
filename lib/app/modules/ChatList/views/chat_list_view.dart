import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:get/get.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  ChatListView({Key? key}) : super(key: key);
  ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return GetBuilder<ChatListController>(builder: (value) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Messages',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 38,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.black,
                size: 30,
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideSwitcher(
                children: [
                  Text(
                    'Latest',
                    style: TextStyle(
                      color: controller.tabIndex == 0
                          ? Colors.white
                          : Color(0xFFBDBDBD),
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Requests (25)',
                    style: TextStyle(
                      color: controller.tabIndex == 1
                          ? Colors.white
                          : Color(0xFFBDBDBD),
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
                onSelect: controller.onUpdateTabIndex,
                containerHeight: 64,
                containerWight: Get.width - 30,
                containerColor: Color(0xFFF2F2F2),
                containerBoxShadow: [
                  BoxShadow(
                    color: Color(0x3529263A),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                    spreadRadius: 0,
                  )
                ],
                slidersGradients: [
                  LinearGradient(
                    begin: Alignment(0.65, -0.76),
                    end: Alignment(-0.65, 0.76),
                    colors: [Color(0xFF6E62F1), Color(0xFF6053BF)],
                  )
                ],
                indents: 5,
              ),

              // CHAT LIST VIEW
              Expanded(
                child: controller.rooms.length == 0
                    ? const Center(
                        child: Text("No Data"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: controller.rooms.length,
                        itemBuilder: (context, index) {
                          Room room = controller.rooms[index];
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
                          // return _roomRow(room, controller.inboxSearchCtl.text);
                          return Container();
                        },
                      ),
              )
            ],
          ),
        ),
      );
    });
  }
}

// Widget _roomRow(Room room, String search) {
//   var color = Colors.transparent;
//   User? otherUser = getOtherUser(room: room);
//   User? _user = getCurrentUser(room: room);
//   String lastMessage = getLastMessage(room: room);
//   int unreadCount = getUnreadCount(room: room);

//   // bool isNSFWAllowed = _user != null
//   //     ? _user.metadata != null
//   //         ? _user.metadata![PrivacySettingKey.COLLECTION] != null
//   //             ? _user.metadata![PrivacySettingKey.COLLECTION]
//   //                         [PrivacySettingKey.ALLOW_NSFW_CONTENTS] !=
//   //                     null
//   //                 ? _user.metadata![PrivacySettingKey.COLLECTION]
//   //                     [PrivacySettingKey.ALLOW_NSFW_CONTENTS]
//   //                 : false
//   //             : false
//   //         : false
//   //     : false;
//   // bool isNSFWMsg = TextFilter.checkMessage(lastMessage);

//   return (otherUser!.firstName!.contains(search) ||
//           otherUser.lastName!.contains(search))
//       ? Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//               onTap: () => controller.onTapRoomEvent(room),
//               onLongPress: () => Get.to(ProfileView(
//                 user: otherUser,
//                 lastMessage: !isNSFWAllowed && isNSFWMsg
//                     ? TextFilter.cleanMessage(lastMessage)
//                     : lastMessage,
//               )),
//               leading: CircleUserAvatar(user: otherUser),
//               title: Text(
//                 getUserName(otherUser!),
//                 style: const TextStyle(
//                   color: white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text(
//                 !isNSFWAllowed && isNSFWMsg
//                     ? TextFilter.cleanMessage(lastMessage)
//                     : lastMessage,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                 ),
//               ),
//               trailing: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     timeAgoSinceDate(
//                       DateTime.fromMillisecondsSinceEpoch(room.updatedAt ?? 0),
//                       numericDates: true,
//                     ),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Visibility(
//                     visible: unreadCount > 0,
//                     child: CircleAvatar(
//                       radius: 10,
//                       backgroundColor: Colors.blue,
//                       child: Text(
//                         unreadCount.toString(),
//                         style: const TextStyle(
//                             color: white,
//                             fontSize: 8,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
//               child: const Divider(
//                 height: 3,
//                 indent: 0.0,
//                 endIndent: 0.0,
//               ),
//             )
//           ],
//         )
//       : const SizedBox();
// }
