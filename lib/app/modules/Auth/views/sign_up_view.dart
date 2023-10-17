import 'package:edmonscan/app/components/back_widget.dart';
import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/components/social_circle_button.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/focus.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends GetView<AuthController> {
  SignUpView({Key? key}) : super(key: key);

  // AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),

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
            'Register',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // --------- Username --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundInputBox(
                      formkey: controller.signUpFormKey,
                      controller: controller.signUpUsernameController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "Username",
                      validate: controller.validateSignupUsername,
                      borderColor: controller.isValidSignupUsername.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidSignupUsername.value
                          ? const Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidSignupUsername.value,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                // --------- PHONE --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //--------- PHONE NUMBER -----------
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: '123 456 7890',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 10, 20, 15),
                        fillColor: controller.isValidSignupPhone.value
                            ? const Color(0x19655AF0)
                            : LightThemeColors.accentColor,
                        filled: true,
                        isDense: true,
                        suffixIcon: controller.isValidSignupPhone.value
                            ? Container(
                                padding: const EdgeInsets.all(14),
                                child: const CircleAvatar(
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
                          borderRadius:
                              BorderRadius.circular(15), //<-- SEE HERE
                          borderSide: BorderSide(
                            color: controller.isValidSignupPhone.value
                                ? LightThemeColors.primaryColor
                                : Colors.grey,
                            width: controller.isValidSignupPhone.value ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15), //<-- SEE HERE
                          borderSide: BorderSide(
                            width: controller.isValidSignupPhone.value ? 2 : 1,
                            color: LightThemeColors.primaryColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.red),
                          borderRadius:
                              BorderRadius.circular(15), //<-- SEE HERE
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.red),
                          borderRadius:
                              BorderRadius.circular(15), //<-- SEE HERE
                        ),
                      ),
                      initialCountryCode: controller.countryCode,
                      onChanged: controller.updateSignUpPhoneNumber,
                      onCountryChanged: (country) {
                        print('Country changed to: ' + country.name);
                      },
                      validator: controller.validateSignUpPhone,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                // --------- Password  --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundInputBox(
                      formkey: controller.signUpFormKey,
                      controller: controller.signUpPasswordController,
                      isSecure: true,
                      radius: 10,
                      hint: ".........",
                      borderColor: controller.isValidSignupOldPass.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidSignupOldPass.value
                          ? const Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidSignupOldPass.value,
                      validate: controller.validateSignupOldPass,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                // --------- CONFIRM PASSWORD --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundInputBox(
                      formkey: controller.signUpFormKey,
                      controller: controller.signUpConfirmpassController,
                      isSecure: true,
                      radius: 10,
                      hint: ".........",
                      borderColor: controller.isValidSignupNewPass.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidSignupNewPass.value
                          ? const Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidSignupNewPass.value,
                      validate: controller.validateSignupNewPass,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: controller.isAccept.value,
                        onChanged: controller.updateAcceptCheck),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Be creating your account you agree with our ',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 13,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'Teams and conditions',
                              style: TextStyle(
                                color: Color(0xFF655AF0),
                                fontSize: 13,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                                // height: 0.16,
                              ),
                            ),
                          ],
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

                    controller.onSignUp();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have account ? ',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Get.back();
                          },
                        style: const TextStyle(
                          color: Color(0xFF655AF0),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          // height: 0.09,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
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
              // controller.signUpWithEmail();
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
          const TextSpan(
            text: 'By signing up, you agree to our ',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: 'Terms and Policy',
            style: const TextStyle(color: Colors.blue),
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
