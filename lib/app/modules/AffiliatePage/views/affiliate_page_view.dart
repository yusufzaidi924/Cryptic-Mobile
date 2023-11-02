import 'package:edmonscan/app/components/round_input.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controllers/affiliate_page_controller.dart';

class AffiliatePageView extends GetView<AffiliatePageController> {
  AffiliatePageView({Key? key}) : super(key: key);
  final controller = Get.put(AffiliatePageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AffiliatePageController>(builder: (value) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Affiliate Program',
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
            icon: const Icon(Icons.arrow_back_ios,
                color: LightThemeColors.primaryColor),
          ),
          actions: [],
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              // --------- DESCRIPTION IMAGE ---------
              Container(
                width: Get.width,
                color: Colors.white,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Earn Money By Referring Friends!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/pic_box.png',
                        width: 95,
                        height: 95,
                      ),
                    ),
                    const Text(
                      'Earn up to \$25 for each friend that signs up & funds their account*',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: Get.width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send Referral Code',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: controller.formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                hintText: '123 456 7890',
                                counterText: '',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 10, 20, 15),
                                fillColor: controller.isValidPhoneNumber.value
                                    ? const Color(0x19655AF0)
                                    : LightThemeColors.accentColor,
                                filled: true,
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(15), //<-- SEE HERE
                                  borderSide: BorderSide(
                                    color: controller.isValidPhoneNumber.value
                                        ? LightThemeColors.primaryColor
                                        : Colors.grey,
                                    width: controller.isValidPhoneNumber.value
                                        ? 2
                                        : 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(15), //<-- SEE HERE
                                  borderSide: BorderSide(
                                    width: controller.isValidPhoneNumber.value
                                        ? 2
                                        : 1,
                                    color: LightThemeColors.primaryColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.red),
                                  borderRadius:
                                      BorderRadius.circular(15), //<-- SEE HERE
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.red),
                                  borderRadius:
                                      BorderRadius.circular(15), //<-- SEE HERE
                                ),
                              ),
                              initialCountryCode: controller.countryCode,
                              onChanged: controller.updatePhoneNumber,
                              onCountryChanged: (country) {
                                print('Country changed to: ' + country.name);
                              },
                              validator: controller.validatePhoneNumber,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              controller.onSendRefCode();
                            },
                            child: Container(
                              width: 77,
                              height: 45,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF655AF0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Learn more about referrals.',
                            style: TextStyle(
                              color: Color(0xFF6E6E82),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.onCopyLink();
                          },
                          child: Container(
                            width: 92,
                            height: 36,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF8F8F8),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFE5E5E5)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Copy link',
                                style: TextStyle(
                                  color: Color(0xFF23233F),
                                  fontSize: 14,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              // --------- Friend List --------
              Expanded(
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.refUsers.length,
                    // itemCount: 10,
                    itemBuilder: (context, index) {
                      UserModel user =
                          //  controller
                          //     .authCtrl.authUser!;
                          controller.refUsers[index];
                      return listUserItme(user);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  listUserItme(UserModel user) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LightThemeColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(300),
                ),
                child: user.selfie != null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            NetworkImage("${Network.BASE_URL}${user.selfie!}"),
                        radius: 22,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/default.png"),
                        radius: 22,
                      ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user.firstName} ${user.lastName}"),
                    SizedBox(height: 10),
                    Text(
                      '${user.phone}',
                      style: TextStyle(
                        color: Color(0xFF6E6E82),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.onDeleteHistory(user);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Color(0xFFEB5A5A),
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
