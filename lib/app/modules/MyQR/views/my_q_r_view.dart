import 'package:dotted_line/dotted_line.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/my_q_r_controller.dart';

class MyQRView extends GetView<MyQRController> {
  MyQRView({Key? key}) : super(key: key);
  final controller = Get.put(MyQRController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEFF3),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text('My QR'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              AntDesign.upload,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // QR & ADDRESS PART
            Container(
              width: Get.width,
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: LightThemeColors.primaryColor, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "BTC Address:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "${controller.authCtrl.btcService!.walletAddress}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.copyToClipboard(
                                    "${controller.authCtrl.btcService!.walletAddress}");
                              },
                              icon: Icon(
                                Icons.copy_outlined,
                                color: LightThemeColors.primaryColor,
                                size: 24,
                              ))
                        ],
                      ),
                    ),
                    QrImageView(
                      data:
                          'BTC:${controller.authCtrl.btcService!.walletAddress}',
                      version: QrVersions.auto,
                      size: Get.width * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: const DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: LightThemeColors.primaryColor,
                        // dashGradient: [Colors.red, Colors.blue],
                        // dashRadius: 0.0,
                        dashGapLength: 6.0,
                        dashGapColor: Colors.transparent,
                        // dashGapGradient: [Colors.red, Colors.blue],
                        // dashGapRadius: 0.0,
                      ),
                    ),
                    Text(
                      'Scan this code to receive\ncrypto to your wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 20,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: LightThemeColors.primaryColor,
                      child: Icon(
                        AntDesign.download,
                        color: Colors.white,
                        size: 25,
                      ),
                      radius: 26,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),

            // ACTION BUTTONS
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SCAN QR
                  InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: Image.asset(
                            'assets/images/scan.png',
                            width: 35,
                            height: 35,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          'QR Scan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),

                  // MY QR
                  InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: Image.asset(
                            'assets/images/qr.png',
                            width: 35,
                            height: 35,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          'My QR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // GETBACK BUTTON
            Container(
              width: Get.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
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
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
