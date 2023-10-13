import 'package:edmonscan/app/modules/Welcome/views/terms_view.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  WelcomeView({Key? key}) : super(key: key);
  WelcomeController controller = Get.put(WelcomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WelcomeController>(
        init: WelcomeController(),
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/welcome1.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
                Image.asset(
                  'assets/images/welcome2.png',
                  fit: BoxFit.contain,
                  width: Get.width * 0.3,
                ),
                Column(
                  children: [
                    Text(
                      'Criptacy: Send & Receive',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 24,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Send and Receive Crypto from family & friends\nUsing Our Secure Platform.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    )
                  ],
                ),
                MaterialButton(
                  color: LightThemeColors.primaryColor,
                  minWidth: double.infinity,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    // controller.signInWithEmail();
                    Get.toNamed(Routes.HOME);
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
              ],
            ),
          );
        },
      ),
    );
  }
}
