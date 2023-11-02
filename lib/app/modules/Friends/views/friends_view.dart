import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/friends_controller.dart';

class FriendsView extends GetView<FriendsController> {
  FriendsView({Key? key}) : super(key: key);
  FriendsController controller = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendsController>(
        // init: FriendsController(),
        builder: (value) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Friends',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios,
                color: LightThemeColors.primaryColor),
          ),
          actions: [
            if (controller.isAddNew.value)
              IconButton(
                icon: Icon(Icons.save_outlined,
                    color: LightThemeColors.primaryColor),
                onPressed: () {
                  value.onSave();
                },
              ),
            if (controller.isAddNew.value)
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  controller.onAddNew(false);
                },
              ),
          ],
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              // --------- Add New Friend ------
              InkWell(
                onTap: () {
                  value.onAddNew(true);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  width: Get.width,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: LightThemeColors.primaryColor),
                            ),
                            child: Icon(Icons.add,
                                color: LightThemeColors.primaryColor, size: 16),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Add New Friend',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // --------- Friend List --------
              Expanded(
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListView.builder(
                    itemCount: value.groupedUsers.length,
                    itemBuilder: (context, index) {
                      String firstChar =
                          value.groupedUsers.keys.elementAt(index);
                      List<UserModel> users = value.groupedUsers[firstChar]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: ShapeDecoration(
                              color: Color(0xFF655AF0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Center(
                              child: Text(
                                firstChar,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              UserModel user = users[index];
                              return listUserItme(user);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  listUserItme(UserModel user) {
    bool isChecked = controller.friendList.contains("${user.id}");
    return InkWell(
      onTap: () {
        controller.onAddOne(user.id, !isChecked);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // CHECK

                if (controller.isAddNew.value)
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      print("✨✨✨✨✨");
                      print(value);
                      controller.onAddOne(user.id, value!);
                    },
                    activeColor: LightThemeColors.primaryColor,
                  ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: LightThemeColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: user.selfie != null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              "${Network.BASE_URL}${user.selfie!}"),
                          radius: 22,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/default.png"),
                          radius: 22,
                        ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.firstName} ${user.lastName}"),
                      SizedBox(height: 10),
                      Text(
                        '${user.phone}',
                        style: TextStyle(
                          color: Color(0xFF6E6E82),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
