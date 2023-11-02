import 'package:edmonscan/app/components/creditCard.dart';
import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/cardnumber_input_formatter.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
            'Add New Card',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                controller.onAddBank();
              },
              icon: Icon(
                Icons.account_balance,
                color: LightThemeColors.primaryColor,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
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
                      controller: controller.cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormatter(),
                      ],
                      hint: "4242 4242 4242 4242",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidNumber.value,
                      validate: controller.validateCardNumber,
                    )
                  ],
                ),
              ),

              // -------------- EXPIRATION DATE -------------
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
                      'Expiration Date',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.expDateController,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      hint: "12/24",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidExpDate.value,
                      validate: controller.validateExpDate,
                    )
                  ],
                ),
              ),

              // -------------- CVV -------------
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
                      'CVV',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.cvvController,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      hint: "123",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidCvv.value,
                      validate: controller.validateCardCVV,
                    )
                  ],
                ),
              ),

              // -------------- CARD MODEL ---------
              Container(
                color: Colors.white,
                width: Get.width,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Card',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    CreditCard(
                      cardNumber: controller.cardNumberController.text,
                      holderName: controller.authCtrl
                          .getUserName(controller.authCtrl.authUser),
                      expDate: controller.expDateController.text,
                    )
                  ],
                ),
              ),
              // -------------- SAVE BUTTON --------
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: InkWell(
                  onTap: () {
                    controller.onSaveCard();
                  },
                  child: Container(
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF655AF0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Add New Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      );
    });
  }
}
