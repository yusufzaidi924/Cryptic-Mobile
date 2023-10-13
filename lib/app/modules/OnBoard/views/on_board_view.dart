import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/app/modules/Auth/views/sign_in_view.dart';
import 'package:edmonscan/app/modules/Auth/views/sign_up_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/on_board_controller.dart';

class OnBoardView extends GetView<OnBoardController> {
  OnBoardView({Key? key}) : super(key: key);
  OnBoardController controller = Get.put(OnBoardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(110)),
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setHeight(250),
            decoration: const BoxDecoration(
              color: MyColors.backgroundColor1,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Image.asset(
              "assets/images/apple_icon.png",
            ),
          ),
          Expanded(child: Container()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome To EdMon Scan",
                style: TextStyle(
                  fontSize: 26,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Get.to(() => SignInView());
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyColors.yellowButtonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                      onPressed: () {
                        Get.to(() => SignUpView());
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyColors.primaryButtonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
