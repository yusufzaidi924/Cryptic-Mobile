import 'package:edmonscan/app/modules/AffiliatePage/controllers/affiliate_page_controller.dart';
import 'package:edmonscan/app/modules/Friends/controllers/friends_controller.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  MyProfileView({Key? key}) : super(key: key);
  MyProfileController controller = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(builder: (value) {
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
            'Profile',
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
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --------- USER INFO ------
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: Get.width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        value.authCtrl.authUser?.selfie != null
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    "${Network.BASE_URL}${value.authCtrl.authUser?.selfie}"),
                                radius: 32,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/avatar.png',
                                ),
                                radius: 32,
                              ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value.authCtrl.chatUser != null
                                  ? getUserName(value.authCtrl.chatUser!)
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${value.authCtrl.authUser?.phone ?? ""}',
                              style: TextStyle(
                                color: Color(0xFF6E6E82),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ------------ BALANCE STATUS ------
              Container(
                width: Get.width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membership',
                          style: TextStyle(
                            color: Color(0xFF23233F),
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Color(0xFF3DAB24),
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Divider(
                        color: Color(0xFFE7E6E6),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance in USD',
                          style: TextStyle(
                            color: Color(0xFF23233F),
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '\$12,769.00',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF23233F),
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //------------- MENU -------
              Container(
                width: Get.width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return value.menuList[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Divider(
                          color: Color(0xFFE7E6E6),
                        ),
                      );
                    },
                    itemCount: value.menuList.length),
              ),

              // -------------- BUTTON ---------------
              InkWell(
                onTap: () {
                  value.onLogout();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: ShapeDecoration(
                    color: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log Out',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
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

menuItem({required Widget icon, required String title, required String route}) {
  return ListTile(
    onTap: () {
      Get.delete<FriendsController>();
      Get.delete<AffiliatePageController>();
      Get.toNamed(route);
    },
    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    leading: icon,
    title: Text(
      '${title}',
      style: const TextStyle(
        color: Color(0xFF23233F),
        fontSize: 16,
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w400,
      ),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 12,
      color: Colors.black,
    ),
  );
}
