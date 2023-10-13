import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/confirm_payment_controller.dart';

class ConfirmPaymentView extends GetView<ConfirmPaymentController> {
  ConfirmPaymentView({Key? key}) : super(key: key);
  ConfirmPaymentController controller = Get.put(ConfirmPaymentController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmPaymentController>(builder: (value) {
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
            'Confirm Your Transfer',
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --------- CONFIRM AVATAR ------
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                width: Get.width * 0.3,
                height: Get.width * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/confirm_avatar.png'),
                  ),
                ),
              ),

              Text(
                'Enter OTP SMS Code To Verify This Transfer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),

              //------------- OTP CODE -------
              Container(
                width: Get.width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Your OTP Code',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "845-784",
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

              SizedBox(height: 20),
              //-------------- TIME --------
              Text(
                'RESEND CODE IN : 00:39',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4363F6),
                  fontSize: 18,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                ),
              ),
              SizedBox(height: 30),
              // --------- AGREEMENT -----
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree with the ',
                                style: TextStyle(
                                  color: Color(0xFF23233F),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms and conditions.',
                                style: TextStyle(
                                  color: Color(0xFF655AF0),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        // SizedBox(
                        //   wid, th: 10,
                        // ),
                        Expanded(
                          child: Text(
                            'I understand that all transfers are final once sent and can not be reversed, cancelled or refunded.',
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 13,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // -------------- BUTTON ---------------
              InkWell(
                onTap: () {
                  // value.onTransfer();
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
                          'CONFIRM TRANSFER',
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
