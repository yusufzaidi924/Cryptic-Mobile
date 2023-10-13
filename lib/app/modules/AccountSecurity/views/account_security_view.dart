import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/account_security_controller.dart';

class AccountSecurityView extends GetView<AccountSecurityController> {
  AccountSecurityView({Key? key}) : super(key: key);
  AccountSecurityController controller = Get.put(AccountSecurityController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountSecurityController>(builder: (value) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Account Security',
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
            icon: Icon(Icons.arrow_back_ios,
                color: LightThemeColors.primaryColor),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // ------------ CURRENT PASSWORD ------
              Container(
                width: Get.width,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Current Password',
                      style: TextStyle(
                        color: Color(0xFF7E7E91),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------ NEW PASSWORD ------
              Container(
                width: Get.width,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter New Password',
                      style: TextStyle(
                        color: Color(0xFF7E7E91),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // --------------UPDATE PASSWORD BUTTON ---------------
              InkWell(
                onTap: () {
                  // value.onRequestPayment();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: ShapeDecoration(
                    color: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Password',
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
              ),

              //-------------- DELETE ACCOUNT BUTTON ---------------------

              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Account?',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Please Type “DELETE ACCOUNT”',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        width: 327,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 205, 0, 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'DELETE MY ACCOUNT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'WARNING: DELETING YOUR ACCOUNT IS PERMANENT AND IRREVERSIBLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
