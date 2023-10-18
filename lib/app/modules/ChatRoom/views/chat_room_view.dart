import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({Key? key}) : super(key: key);
  final controller = Get.put(ChatRoomController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    Color _backgroudColor = Color.fromARGB(255, 236, 236, 236);

    return GetBuilder<ChatRoomController>(builder: (value) {
      /***********************
   * Other User Avatar
   */
      _otherUser(ChatRoomController controller) {
        User? otherUser = controller.room != null
            ? getOtherUser(room: controller.room!)
            : null;
        return Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              otherUser != null
                  ? CircleAvatar(
                      backgroundColor: Color.fromARGB(182, 211, 211, 211),
                      backgroundImage: NetworkImage(
                          "${Network.BASE_URL}${otherUser.imageUrl}"),
                      radius: 28,
                    )
                  : CircleAvatar(
                      backgroundColor: Color.fromARGB(182, 211, 211, 211),
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 28,
                    ),
              SizedBox(
                width: 20,
              ),
              Text(
                '${otherUser?.firstName ?? ""} ${otherUser?.lastName ?? ""}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        backgroundColor: LightThemeColors.primaryColor,
        appBar: AppBar(
          backgroundColor: LightThemeColors.primaryColor,
          // title: const Text('ChatRoomView'),
          // centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                // Perform an action when a menu item is selected
                print('Selected: $result');
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'option1',
                  child: Text('Option 1'),
                ),
                PopupMenuItem<String>(
                  value: 'option2',
                  child: Text('Option 2'),
                ),
                PopupMenuItem<String>(
                  value: 'option3',
                  child: Text('Option 3'),
                ),
              ],
            ),
          ],
          elevation: 0,
        ),
        body: Container(
          child: Column(
            children: [
              _otherUser(controller),
              Expanded(
                child: Container(
                  decoration: ShapeDecoration(
                    color: _backgroudColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 32),
                    child: Chat(
                      theme: DefaultChatTheme(
                        inputBackgroundColor: Colors.white,
                        backgroundColor: _backgroudColor,
                        inputTextColor: Colors.black,
                        inputTextCursorColor: LightThemeColors.primaryColor,
                      ),
                      messages: controller.messages,
                      onAttachmentPressed: controller.handleAttachmentPressed,
                      onMessageTap: (BuildContext context, message) {
                        controller.handleMessageTap(message);
                      },
                      onPreviewDataFetched: controller.handlePreviewDataFetched,
                      onSendPressed: controller.handleSendPressed,
                      showUserAvatars: true,
                      showUserNames: true,
                      user: controller.authCtrl.chatUser!,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
