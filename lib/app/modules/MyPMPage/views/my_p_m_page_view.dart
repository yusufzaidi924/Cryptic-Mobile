import 'package:edmonscan/app/components/bell_widget.dart';
import 'package:edmonscan/app/components/creditCard.dart';
import 'package:edmonscan/app/components/slider_effect_widget.dart';
import 'package:edmonscan/app/components/top_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/my_p_m_page_controller.dart';

class MyPMPageView extends GetView<MyPMPageController> {
  MyPMPageView({Key? key}) : super(key: key);
  MyPMPageController controller = Get.put(MyPMPageController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return GetBuilder<MyPMPageController>(builder: (value) {
      return Scaffold(
        // backgroundColor: C,
        body: Column(
          children: [
            //-------- HEADER---------------
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 37),
                  color: Colors.white,
                  child: Container(
                    width: Get.width,
                    height: 185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            '\$12,769.00',
                            style: TextStyle(
                              color: Color(0xFFFEBC11),
                              fontSize: 24,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //---------- BACK ARROW ICON --------
                Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),

                //---------- NOTIFICATION ICON --------
                Positioned(
                  right: 30,
                  top: 50,
                  child: BellWidget(
                    isShowBadge: true,
                    onTap: () {},
                  ),
                ),

                //---------- TOP NAVBAR --------
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: Get.width,
                    height: 74,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x193D566E),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                            spreadRadius: -2,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // TOP UP
                          topItemMenu(
                            onTap: () {
                              value.goTopUp();
                            },
                            icon: 'assets/images/topup.png',
                            title: "Top up",
                          ),

                          // WALLET
                          topItemMenu(
                            onTap: () {},
                            icon: 'assets/images/wallet.png',
                            title: "Wallet",
                          ),

                          // QR Scan

                          topItemMenu(
                            onTap: () {},
                            icon: 'assets/images/scan.png',
                            title: "QR Scan",
                          ),

                          // My QRCode
                          topItemMenu(
                            onTap: () {},
                            icon: 'assets/images/qr.png',
                            title: "My QR",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  //------- ADD NEW CARD BUTTON ---------
                  Container(
                    width: Get.width,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          value.goAddNewCard();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 58,
                          decoration: ShapeDecoration(
                            color: Color(0xFF655AF0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x193D566E),
                                blurRadius: 12,
                                offset: Offset(0, 3),
                                spreadRadius: -2,
                              )
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                // PLUS ICON
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),

                                Text(
                                  'Add New Card',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: Get.width,
                          margin: EdgeInsets.only(bottom: 15),
                          // height: 170,
                          child: SliderEffect(
                            width: Get.width,
                            height: 180,
                            onDelete: () {
                              print("DEELEEETEET");
                            },
                            child: CreditCard(
                              cardNumber: '4220',
                              holderName: "Genius Dev",
                              expDate: '02/25',
                            ),
                          ),
                        );
                      },
                      itemCount: 5,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
