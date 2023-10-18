import 'package:edmonscan/app/components/circle_user_avatar%20copy.dart';
import 'package:edmonscan/app/data/models/RequestChatModel.dart';
import 'package:edmonscan/app/modules/ChatList/controllers/chat_list_controller.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class RequestChatView extends GetView<ChatListController> {
  const RequestChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: (controller) {
      return controller.requests.length == 0
          ? const Center(
              child: Text("No Requests"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: controller.requests.length,
              itemBuilder: (context, index) {
                // Room room = controller.requests[index];
                // if (controller.requests == null) {
                //   return Container(
                //     child: const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   );
                // }
                if (controller.requests.length == 0) {
                  return const Text("No Requests");
                }
                return _reqquestRow(
                    controller.requests[index], controller.searchTextCtrl.text);
                // return Container();
              },
            );
    });
  }

  Widget _reqquestRow(RequestChatModel request, String search) {
    return ("${request.fromUser!.firstName} ${request.fromUser!.lastName}"
            .contains(search))
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                onTap: () => controller.onTapChatRequest(request),
                // onLongPress: () => Get.to(ProfileView(
                //   user: otherUser,
                //   lastMessage: !isNSFWAllowed && isNSFWMsg
                //       ? TextFilter.cleanMessage(lastMessage)
                //       : lastMessage,
                // )),
                leading: CircleUserAvatar(user: request.fromUser),
                title: Text(
                  "${request.fromUser!.firstName} ${request.fromUser!.lastName}",
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
                    timeAgoSinceDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          request.createdAt ?? 0),
                      numericDates: true,
                    ),
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                trailing: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check,
                        color: LightThemeColors.primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
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
