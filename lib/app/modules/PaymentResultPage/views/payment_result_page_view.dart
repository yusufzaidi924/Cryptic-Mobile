import 'package:dotted_border/dotted_border.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/payment_result_page_controller.dart';

class PaymentResultPageView extends GetView<PaymentResultPageController> {
  const PaymentResultPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: LightThemeColors.primaryColor,
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blue_back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),

              //--------- SHARE ICON -------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/upload_icon.png'),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              //--------- ALERT BOX ---------
              Stack(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Container(
                      width: double.infinity,
                      // height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            child: Text(
                              'Withdrawal Successful',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 24,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'We’ve received your request to \nwithdraw. Please allow time for processing.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E82),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Total Amount',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E82),
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$ 123.00',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 24,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            width: double.infinity,
                            height: 3,
                            child: Image.asset(
                              'assets/images/dotted_line.png',
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: Get.width / 2 - 75,
                    top: 0,
                    child: Container(
                      width: 150,
                      height: 64,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 41,
                            top: 0,
                            child: Container(
                              width: 64,
                              height: 64,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: OvalBorder(),
                                        shadows: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                111, 104, 104, 104),
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: 8,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF3DAB24),
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 20,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 23,
                            child: Container(
                              width: 149,
                              height: 37,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 143,
                                    top: 20,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF3DAB24),
                                        shape: OvalBorder(),
                                        shadows: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                111, 104, 104, 104),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 114,
                                    top: 0,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF3DAB24),
                                        shape: OvalBorder(
                                          side: BorderSide(
                                              width: 3, color: Colors.white),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                111, 104, 104, 104),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 19,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF3DAB24),
                                        shape: OvalBorder(
                                          side: BorderSide(
                                              width: 3, color: Colors.white),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                111, 104, 104, 104),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: LightThemeColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: LightThemeColors.primaryColor,
                    ),
                  )
                ],
              ),

              //-------- ACTION PART -----------
              Stack(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            // height: 72,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF8F8F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                  radius: 25,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                    SizedBox(height: 5),
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
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: 30),
                          // ------------ BUTTON --------
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Color(0xFF655AF0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    left: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: LightThemeColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    top: -20,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: LightThemeColors.primaryColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
