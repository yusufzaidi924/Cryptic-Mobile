import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  UserProfileView({Key? key}) : super(key: key);
  UserProfileController controller = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(builder: (value) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF23233F),
            ),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: Text('Option 1'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Option 2'),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text('Option 3'),
                  value: 3,
                ),
              ],
              icon: Icon(
                Icons.more_vert,
                color: Color(0xFF23233F),
              ),
              onSelected: (value) {
                // Handle menu item selection
              },
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----------- Avatar --------------
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 25),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  radius: 45,
                ),
              ),

              //---------- NAME ----------
              Text(
                'Jonathan Doe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2A2C2E),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //--------- REPORT & BLOCK ----------
              Text(
                'Report/Block User',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  // letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //--------- ICON BAR -----------
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // SEND ICON
                        InkWell(
                          onTap: () {
                            value.goToTransferPage();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //       'assets/images/transfer_icon.png',
                            //     ),
                            //   ),
                            // ),
                            child: Image.asset(
                              'assets/images/transfer_icon.png',
                              color: LightThemeColors.primaryColor,
                              fit: BoxFit.contain,
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                        Text(
                          'Send',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2A2C2E),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        value.goToRequestPayment();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //       'assets/images/transfer_icon.png',
                            //     ),
                            //   ),
                            // ),
                            child: Image.asset(
                              'assets/images/trans_his_icon.png',
                              color: LightThemeColors.primaryColor,
                              fit: BoxFit.contain,
                              width: 35,
                              height: 35,
                            ),
                          ),
                          Text(
                            'Request',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2A2C2E),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Remove User
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.person_remove_alt_1_outlined,
                            color: LightThemeColors.primaryColor,
                            size: 35,
                          ),
                        ),
                        Text(
                          'Remove Friend',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2A2C2E),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 30,
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2A2C2E),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Expanded(
                child: Container(
                  height: double.infinity,
                  child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: Get.width,
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: SizedBox(
                              width: 355,
                              child: Text(
                                'Thursday - Oct 28 4:59PM (BTC)',
                                style: TextStyle(
                                  color: Color(0xFF2A2C2E),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '85332394655434937',
                                    style: TextStyle(
                                      color: Color(0xFFB0B0B2),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    '\$.039301 BTC',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFB0B0B2),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                    ),
                                  )
                                ]),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
