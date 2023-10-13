import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_new_card_controller.dart';

class AddNewCardView extends GetView<AddNewCardController> {
  AddNewCardView({Key? key}) : super(key: key);
  AddNewCardController controller = Get.put(AddNewCardController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetBuilder<AddNewCardController>(builder: (value) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEFF3),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: LightThemeColors.primaryColor,
              )),
          title: const Text(
            'Add new card',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            // ------------ CARD NUMBER -----
            Container(
              color: Colors.white,
              width: Get.width,
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Number',
                    style: TextStyle(
                      color: Color(0xFF23233F),
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  UnderLineInputBox(
                    formkey: controller.formKey,
                    controller:controller.cardNumberController,
                    keyboardType: TextInputType.number,
                    hint: "+1 123 456 789",
                     borderColor: controller.isValidCardName.value
                          ? LightThemeColors.primaryColor
                          : null,
                    isValid: controller.isValidCardName.value,
                      validate: controller.validateCardNumber,
                  )
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}
