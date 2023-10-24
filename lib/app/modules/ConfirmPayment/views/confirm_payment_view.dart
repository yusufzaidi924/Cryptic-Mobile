import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';

import '../controllers/confirm_payment_controller.dart';

class ConfirmPaymentView extends GetView<ConfirmPaymentController> {
  ConfirmPaymentView({Key? key}) : super(key: key);
  ConfirmPaymentController controller = Get.put(ConfirmPaymentController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmPaymentController>(builder: (value) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEFF3),
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF23233F),
            ),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  child: Text('Option 1'),
                  value: 1,
                ),
                const PopupMenuItem(
                  child: Text('Option 2'),
                  value: 2,
                ),
                const PopupMenuItem(
                  child: Text('Option 3'),
                  value: 3,
                ),
              ],
              icon: const Icon(
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
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: Get.width * 0.3,
                height: Get.width * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/confirm_avatar.png'),
                  ),
                ),
              ),

              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Enter OTP SMS Code To Verify This Transfer',
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //------------- OTP CODE -------
              Container(
                width: Get.width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Your OTP Code',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: LightThemeColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      fieldWidth: Get.width / 8,

                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) {
                        controller.setVerifyCode(verificationCode);
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: Text("Verification Code"),
                        //         content: Text('Code entered is $verificationCode'),
                        //       );
                        //     });
                      }, // end onSubmit
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              //-------------- TIME --------
              Builder(builder: (context) {
                String time = formatTimerTime(controller.estimateTime);
                return Text(
                  'RESEND CODE IN : $time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4363F6),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                    height: 0.09,
                  ),
                );
              }),
              const SizedBox(height: 30),
              // --------- AGREEMENT -----
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: controller.terms1.value,
                            onChanged: (value) {
                              controller.updateTerms1(value);
                            }),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        const Text.rich(
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
                        Checkbox(
                            value: controller.terms2.value,
                            onChanged: (value) {
                              controller.updateTerms2(value);
                            }),
                        // SizedBox(
                        //   wid, th: 10,
                        // ),
                        const Expanded(
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
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: InkWell(
                  onTap: () {
                    controller.verifyCode();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: controller.verifyCode == ''
                          ? Color.fromARGB(236, 117, 112, 184)
                          : LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Container(
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
                            child: const Icon(
                              Icons.arrow_forward,
                              color: LightThemeColors.primaryColor,
                            ),
                          ),
                          const Expanded(
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
