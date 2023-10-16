import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class VerifyResultView extends GetView {
  VerifyResultView({Key? key}) : super(key: key);
  String pendingTitle = "Verification In Progress";
  String pendingDesc =
      "We’re currently verifying your profile. You will be notified once we’re able to verify your identify. \r\n If you need any additional information, we will contact you.\r\r\n\nMost profiles are verified within 24 hours, but in some cases it may take longer.";

  String verifyTitle = "You’re Verified!";
  String verifyDesc =
      "Awesome! You’ve been verified and approved to use our platform. We’re just as excited as you are. Let’s get started!";

  String rejectTitle = "Application Denied";
  String rejectDesc =
      "We’re sorry to inform you, but we could not approve your profile at this time. no further details can be shared at this point in time.\r\n\r\nThank you for your interest in Criptacy.";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            leading: controller.authUser!.status != 2
                ? IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: LightThemeColors.primaryColor,
                    ),
                  )
                : null,
            title: Text(
              controller.authUser!.status == 1
                  ? pendingTitle
                  : controller.authUser!.status == 2
                      ? verifyTitle
                      : controller.authUser!.status == -1
                          ? rejectTitle
                          : "",
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
                        image: AssetImage(controller.authUser!.status == 1
                            ? 'assets/images/id_pending.png'
                            : controller.authUser!.status == 2
                                ? 'assets/images/confirm_icon.png'
                                : 'assets/images/id_reject.png'),
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: 329,
                  child: Text(
                    controller.authUser!.status == 1
                        ? pendingDesc
                        : controller.authUser!.status == 2
                            ? verifyDesc
                            : rejectDesc,
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
                if (controller.authUser!.status == 2)
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

                    if (controller.authUser!.status == 2) {
                      Get.offAllNamed(Routes.WELCOME);
                    } else if (controller.authUser!.status == -1) {
                      // rejected
                      Get.toNamed(Routes.SIGNUP_DETAIL);
                    } else {
                      Get.back();
                      Get.back();
                    }
                    // controller.signInWithEmail();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: Text(
                    controller.authUser!.status == 2
                        ? 'Get Started'
                        : 'Go Back',
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
    });
  }
}
