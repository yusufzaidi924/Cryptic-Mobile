import 'package:edmonscan/app/components/back_widget.dart';
import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/modules/Auth/views/sign_up_view.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controllers/auth_controller.dart';

class SignInView extends GetView<AuthController> {
  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (value) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),

          // automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          // leading: IconButton(
          //   onPressed: () {
          //     Get.back();
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     color: LightThemeColors.primaryColor,
          //   ),
          // ),
          title: Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(),
                const SizedBox(
                  height: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // EMAIL & PASSWORD FROM
                    _buildEmailForm(context),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      " Or With Social Account ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // SOCIAL LOGIN BUTTON PART
                // MaterialButton(
                //   color: Colors.transparent,
                //   onPressed: () {
                //     controller.googleAuthentication(isLogin: true);
                //   },
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //       side: const BorderSide(color: Colors.white, width: 2)),
                //   height: 45,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset("assets/images/google_icon.png"),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       const Text(
                //         'SignIn with Google',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // MaterialButton(
                //   color: Colors.transparent,
                //   onPressed: () {
                //     controller.appleAuthentication(isLogin: true);
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
                //         'SignIn with Apple',
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
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmailForm(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone',
            style: TextStyle(
              color: Color(0xFF6E6E82),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
              height: 0.10,
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //--------- PHONE NUMBER -----------
          IntlPhoneField(
            decoration: InputDecoration(
              hintText: '123 456 7890',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              contentPadding: EdgeInsets.fromLTRB(15, 10, 20, 15),
              fillColor: controller.isValidPhoneNumber.value
                  ? Color(0x19655AF0)
                  : LightThemeColors.accentColor,
              filled: true,
              isDense: true,
              suffixIcon: controller.isValidPhoneNumber.value
                  ? Container(
                      padding: EdgeInsets.all(14),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 4,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), //<-- SEE HERE
                borderSide: BorderSide(
                  color: controller.isValidPhoneNumber.value
                      ? LightThemeColors.primaryColor
                      : Colors.grey,
                  width: controller.isValidPhoneNumber.value ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), //<-- SEE HERE
                borderSide: BorderSide(
                  width: controller.isValidPhoneNumber.value ? 2 : 1,
                  color: LightThemeColors.primaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.red),
                borderRadius: BorderRadius.circular(15), //<-- SEE HERE
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.red),
                borderRadius: BorderRadius.circular(15), //<-- SEE HERE
              ),
            ),
            initialCountryCode: controller.countryCode,
            onChanged: controller.updatePhoneNumber,
            onCountryChanged: (country) {
              print('Country changed to: ' + country.name);
            },
            validator: controller.validatePhoneNumber,
          ),

          //---------- PASSWORD -----------------
          const SizedBox(
            height: 30,
          ),
          Text(
            'Password',
            style: TextStyle(
              color: Color(0xFF6E6E82),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
              height: 0.10,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RoundInputBox(
            formkey: controller.loginFormKey,
            controller: controller.loginPasswordController,
            isSecure: true,
            radius: 10,
            hint: ".........",
            borderColor: controller.isValidLoginPass.value
                ? LightThemeColors.primaryColor
                : null,
            fillColor: controller.isValidLoginPass.value
                ? Color(0x19655AF0)
                : LightThemeColors.accentColor,
            isValid: controller.isValidLoginPass.value,
            validate: controller.validateLoginPass,
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: controller.isSavePass.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateCheckPass(value);
                        }
                      },
                      activeColor: LightThemeColors.primaryColor,
                    ),
                    Text(
                      'Save password',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 13,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Forgot password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF655AF0),
                    fontSize: 13,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 0.12,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: LightThemeColors.primaryColor,
            minWidth: double.infinity,
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();

              // controller.signInWithEmail();
              controller.onSignIn();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            height: 50,
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don’t have account? ',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("CLICKED(((((((((((((((((())))))))))))))))))");
                          // Single tapped.
                          Get.to(SignUpView());
                        },
                      style: TextStyle(
                        color: Color(0xFF655AF0),
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              )
            ],
          )
        ],
      ),
    );
  }
}
