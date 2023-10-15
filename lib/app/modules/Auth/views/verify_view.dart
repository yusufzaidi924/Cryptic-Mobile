import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';

class VerifyView extends GetView {
  VerifyView({Key? key}) : super(key: key);
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (value) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          // automaticallyImplyLeading: false,
          // leading: BackWidget(),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: LightThemeColors.primaryColor,
            ),
          ),
          title: const Text(
            'Verify',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                height: 195,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/verify_back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              const Text(
                'Verify Your Phone',
                style: TextStyle(
                  color: Color(0xFF23233F),
                  fontSize: 24,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 210,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Please enter the 4 digit code sent to ',
                        style: TextStyle(
                          color: Color(0xFF6E6E82),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: controller.isSignInFlow
                            ? "${controller.phoneNumber.value}"
                            : "${controller.signUpphoneNumber.value}",
                        style: const TextStyle(
                          color: Color(0xFF655AF0),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              //---------- Code Panel ------------

              OtpTextField(
                numberOfFields: 6,
                borderColor: LightThemeColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                fieldWidth: 50,

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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  controller.resendOtpCode();
                },
                child: Text(
                  'Request New Code',
                  style: TextStyle(
                    color: Color(0xFF655AF0),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    // textDecoration: TextDecoration.underline,
                    textBaseline: TextBaseline.alphabetic,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              MaterialButton(
                color: controller.verifyCode.value != ""
                    ? LightThemeColors.primaryColor
                    : Color.fromARGB(255, 213, 212, 230),
                minWidth: double.infinity,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  controller.onConfirmVerifyCode();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    });
  }
}
