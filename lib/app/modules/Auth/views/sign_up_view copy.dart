import 'package:edmonscan/app/components/back_widget.dart';
import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/components/social_circle_button.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/focus.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends GetView<AuthController> {
  SignUpView({Key? key}) : super(key: key);

  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackWidget(),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Row(),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              _buildEmailForm(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.white.withOpacity(0.5),
                  //   ),
                  // ),
                  Text(
                    " Or with Email ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.white.withOpacity(0.5),
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.transparent,
                onPressed: () {
                  // controller.googleAuthentication(isLogin: false);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.white, width: 2)),
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/google_icon.png"),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'SignUp with Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // MaterialButton(
              //   color: Colors.transparent,
              //   onPressed: () {
              //     // controller.appleAuthentication(isLogin: false);
              //   },
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //       side: const BorderSide(color: Colors.white, width: 2)),
              //   height: 45,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset("assets/images/apple_icon.png",
              //           width: 22, height: 22),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       const Text(
              //         'SignUp with Apple',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              _agreeTerms(context),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Form(
      key: controller.signUpFormKey,
      child: Column(
        children: [
          // RoundInputBox(
          //   formkey: controller.signUpFormKey,
          //   controller: controller.signUpUsernameController,
          //   hint: "Username",
          //   validate: (value) {
          //     if (value!.isEmpty) {
          //       return 'Username is required.';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          RoundInputBox(
            formkey: controller.signUpFormKey,
            controller: controller.signUpEmailController,
            keyboardType: TextInputType.emailAddress,
            hint: "Your Email",
            validate: (value) {
              if (!Regex.isEmail(value!)) {
                return 'Email format invalid.';
              }

              if (value.isEmpty) {
                return 'Email is required.';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          RoundInputBox(
            formkey: controller.signUpFormKey,
            controller: controller.signUpPasswordController,
            isSecure: true,
            hint: ".........",
            validate: (value) {
              if (value!.length < 6) {
                return 'Password should be at least 6 characters';
              }

              if (value.isEmpty) {
                return 'Password is required.';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          RoundInputBox(
            formkey: controller.signUpFormKey,
            controller: controller.signUpConfirmpassController,
            isSecure: true,
            hint: ".........",
            suffixWidget: Container(
              width: 130,
              padding: const EdgeInsets.only(right: 10),
              child: const Center(
                child: Text(
                  "Confirm Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            validate: (value) {
              if (value!.length < 6) {
                return 'Password should be at least 6 characters';
              }
              if (value != controller.signUpPasswordController.text) {
                return "Password doesn't match";
              }

              if (value.isEmpty) {
                return 'Password is required.';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: MyColors.primaryButtonColor,
            minWidth: double.infinity,
            onPressed: () {
              AppFocus.unfocus(context);
              controller.signUpWithEmail();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            height: 45,
            child: const Text(
              'Sign Up',
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
    );
  }

  Widget _agreeTerms(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By signing up, you agree to our ',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: 'Terms and Policy',
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url =
                    AboutUsLinks.PRIVACY_POLICY; //add your policy link here
                // if (await canLaunch(url)) {
                await launch(url);
                // } else {
                //   throw 'Could not launch $url';
                // }
              },
          ),
        ],
      ),
    );
  }
}
