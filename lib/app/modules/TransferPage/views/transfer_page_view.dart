import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/transfer_page_controller.dart';

class TransferPageView extends GetView<TransferPageController> {
  TransferPageView({Key? key}) : super(key: key);
  TransferPageController controller = Get.put(TransferPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferPageController>(builder: (value) {
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
            'Send Balance',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --------- USER INFO ------
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: Get.width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/avatar.png',
                          ),
                          radius: 28,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jonathan Doe',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '505-287-8051',
                              style: TextStyle(
                                color: Color(0xFF6E6E82),
                                fontSize: 14,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),

              // ------------ SELECT CURRENCY ------
              Container(
                width: Get.width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your currency',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // UnderLineInputBox(
                    //     formkey: formkey,
                    //     controller: controller,
                    //     hint: hint,
                    //     validate: validate)
                  ],
                ),
              ),

              //---------- AMOUNT INPUT --------------
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: Get.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Amount ',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '(Balance: ',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '\$12,769.00',
                              style: TextStyle(
                                color: Color(0xFF655AF0),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ')',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        prefix: Text('\$'),
                        labelText: 'Enter amount',
                        labelStyle: TextStyle(
                          color: LightThemeColors.primaryColor,
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //------------- GREETING OPTION---------
              Container(
                width: Get.width,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Include a Greeting *(optional)',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 100,
                      width: Get.width,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int indext) {
                          return Container(
                            width: 90,
                            height: 80,
                            decoration: ShapeDecoration(
                              color: Color(0xFFEB5A5A).withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Image.asset(
                                'assets/images/greeting_avatar.png'),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 15);
                        },
                      ),
                    )
                  ],
                ),
              ),

              //------------- MESSAGE -------
              Container(
                width: Get.width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Add a message (Limit 120 Characters)',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // -------------- BUTTON ---------------
              InkWell(
                onTap: () {
                  value.onTransfer();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  decoration: ShapeDecoration(
                    color: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 54,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: LightThemeColors.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'SWIPE TO TRANSFER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
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
