import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/components/state_selector.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class SignupDetailView extends GetView {
  SignupDetailView({Key? key}) : super(key: key);
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (value) {
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
            'Profile Details',
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
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.detailFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),

                // --------- Username --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name',
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
                      formkey: controller.detailFormKey,
                      controller: controller.detailFirstNameController,
                      radius: 10,
                      hint: "John",
                      borderColor: controller.isValidDetailFName.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailFName.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailFName.value,
                      validate: controller.validateFName,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- Last Name --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Name',
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
                      formkey: controller.detailFormKey,
                      controller: controller.detailLastNameController,
                      radius: 10,
                      hint: "Doe",
                      borderColor: controller.isValidDetailLName.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailLName.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailLName.value,
                      validate: controller.validateLName,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- Street Address --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Street Address',
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
                      formkey: controller.detailFormKey,
                      controller: controller.streetController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "123 Happy Street",
                      borderColor: controller.isValidDetailStreet.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailStreet.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailStreet.value,
                      validate: controller.validateStreet,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- City --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City',
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
                      formkey: controller.detailFormKey,
                      controller: controller.cityController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "Miami",
                      borderColor: controller.isValidDetailCity.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailCity.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailCity.value,
                      validate: controller.validateDetailCity,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- State --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'State',
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
                    StateSelector(
                      onChange: () {},
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- ZipCode --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zip Code',
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
                      formkey: controller.detailFormKey,
                      controller: controller.zipController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "33131",
                      borderColor: controller.isValidDetailZip.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailZip.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailZip.value,
                      validate: controller.validateDetailZip,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- Birthday --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of Birth',
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
                      formkey: controller.detailFormKey,
                      controller: controller.birthController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "MM/DD/YYYY",
                      suffixWidget: IconButton(
                        onPressed: () async {
                          await controller.selectBirthday();
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                      borderColor: controller.isValidDetailBirth.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailBirth.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailBirth.value,
                      validate: controller.validateDetailCity,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- Email --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
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
                      formkey: controller.detailFormKey,
                      controller: controller.detailEmailController,
                      keyboardType: TextInputType.emailAddress,
                      radius: 10,
                      hint: "hello@criptacy.com",
                      borderColor: controller.isValidDetailEmail.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailEmail.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailEmail.value,
                      validate: controller.validateDetailEmail,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                // --------- Driver’s License State --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver’s License State',
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
                    StateSelector(
                      onChange: () {},
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // --------- Driver’s License Number --------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver’s License Number',
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
                      formkey: controller.detailFormKey,
                      controller: controller.licenseNumberController,
                      keyboardType: TextInputType.text,
                      radius: 10,
                      hint: "********* 0000",
                      borderColor: controller.isValidDetailLNumber.value
                          ? LightThemeColors.primaryColor
                          : null,
                      fillColor: controller.isValidDetailLNumber.value
                          ? Color(0x19655AF0)
                          : LightThemeColors.accentColor,
                      isValid: controller.isValidDetailLNumber.value,
                      validate: controller.validateDetailCity,
                    ),
                  ],
                ),

                // --------- KYC FRONT --------------
                SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please upload a front photo of your ID',
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
                    InkWell(
                      onTap: () {
                        controller.showBottomSheetIDPhoto(
                            context, DOCUMENT_ID.FRONT_ID);
                      },
                      child: Container(
                        width: Get.width,
                        height: controller.fID.value != null ? 150 : 48,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          image: controller.fID.value != null
                              ? DecorationImage(
                                  image: FileImage(controller.fID.value!))
                              : null,
                        ),
                        child: controller.fID.value != null
                            ? null
                            : Text(
                                'Click here to upload document',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF421EB7),
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.9,
                                ),
                              ),
                      ),
                    )
                  ],
                ),

                // --------- KYC BACK --------------
                SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please upload a back photo of your ID',
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
                    InkWell(
                      onTap: () {
                        controller.showBottomSheetIDPhoto(
                            context, DOCUMENT_ID.BACK_ID);
                      },
                      child: Container(
                        width: Get.width,
                        height: controller.bID.value != null ? 150 : 48,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          image: controller.bID.value != null
                              ? DecorationImage(
                                  image: FileImage(controller.bID.value!))
                              : null,
                        ),
                        child: controller.bID.value != null
                            ? null
                            : Text(
                                'Click here to upload document',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF421EB7),
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.9,
                                ),
                              ),
                      ),
                    )
                  ],
                ),

                // --------- KYC SELFE --------------
                SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please upload a clearly visible selfie of your holding your ID in a clearly visible manner.',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        controller.showBottomSheetIDPhoto(
                            context, DOCUMENT_ID.SELFIE);
                      },
                      child: Container(
                        width: Get.width,
                        height: controller.selfie.value != null ? 150 : 48,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          image: controller.selfie.value != null
                              ? DecorationImage(
                                  image: FileImage(controller.selfie.value!))
                              : null,
                        ),
                        child: controller.selfie.value != null
                            ? null
                            : Text(
                                'Click here to upload document',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF421EB7),
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.9,
                                ),
                              ),
                      ),
                    )
                  ],
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
                    Get.toNamed(Routes.VERIFY_RESULT_PAGE);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: const Text(
                    'Submit Profile',
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
          ),
        ),
      );
    });
  }
}
