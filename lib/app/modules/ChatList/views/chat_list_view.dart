import 'package:edmonscan/app/components/circle_user_avatar%20copy.dart';
import 'package:edmonscan/app/components/circle_user_avatar.dart';
import 'package:edmonscan/app/modules/ChatList/views/chat_room_list_view.dart';
import 'package:edmonscan/app/modules/ChatList/views/request_chat_view.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  ChatListView({Key? key}) : super(key: key);
  // ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return GetBuilder<ChatListController>(
        init: ChatListController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: controller.isOpenSearch
                  ? LightThemeColors.primaryColor
                  : Colors.white,
              leading: controller.isOpenSearch
                  ? IconButton(
                      onPressed: () => controller.updateSearchStatus(false),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
              title: controller.isOpenSearch
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        controller: controller.searchTextCtrl,
                        onChanged: (String? value) =>
                            {controller.onSearchUpdate(value)},
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : const Text(
                      'Messages',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 24,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              actions: [
                if (!controller.isOpenSearch)
                  IconButton(
                    onPressed: () => controller.updateSearchStatus(true),
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
                    color:
                        controller.isOpenSearch ? Colors.white : Colors.black,
                    size: 30,
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: LightThemeColors.primaryColor,
              onPressed: () {
                // Perform action when FAB is pressed

                controller.onAddChat();
              },
              child: Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
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
                        'Requests (${controller.requests.length})',
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
                      ),
                    ],
                    indents: 8,
                    initialIndex: controller.tabIndex,
                  ),

                  // CHAT LIST VIEW
                  Expanded(
                    child: PageView(
                      physics:
                          NeverScrollableScrollPhysics(), // Disable swipe gesture
                      controller: controller.pageController,
                      // onPageChanged: controller.onPageChanged,
                      children: [
                        // CHAT ROOM LSIT
                        ChatRoomListView(),
                        RequestChatView(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
