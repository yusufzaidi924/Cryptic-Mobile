import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class VerifyResultView extends GetView {
  VerifyResultView({Key? key}) : super(key: key);
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: LightThemeColors.primaryColor,
            ),
          ),
          title: Text(
            'You’re Verified!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              // ----------Icons ----------
              Container(
                height: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/confirm_icon.png'),
                      fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: 329,
                child: Text(
                  'Awesome! You’ve been verified and approved to use our platform. We’re just as excited as you are. Let’s get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6E6E82),
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Welcome To Criptacy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),

              SizedBox(
                height: 30,
              ),

              MaterialButton(
                color: LightThemeColors.primaryColor,
                minWidth: double.infinity,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  // controller.signInWithEmail();
                  Get.toNamed(Routes.WELCOME);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Need Help ? ',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 0.09,
                      ),
                    ),
                    TextSpan(
                      text: 'Contact Support',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // Get.back();
                        },
                      style: TextStyle(
                        color: Color(0xFF655AF0),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        // height: 0.09,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
  }
}
