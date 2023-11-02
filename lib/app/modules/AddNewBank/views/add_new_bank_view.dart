import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_new_bank_controller.dart';

class AddNewBankView extends GetView<AddNewBankController> {
  AddNewBankView({Key? key}) : super(key: key);
  final controller = Get.put(AddNewBankController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetBuilder<AddNewBankController>(builder: (value) {
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
            'Add New Bank',
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
            // IconButton(
            //   onPressed: () {
            //     // controller.onAddBank();
            //   },
            //   icon: Icon(
            //     Icons.account_balance,
            //     color: LightThemeColors.primaryColor,
            //   ),
            // )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(children: [
              // ------------ DESCRIPTION -------
              Container(
                  color: Colors.white,
                  width: Get.width,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFEBC11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Enter Bank Details Below',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )),
              // ------------ ACCOUNT NUMBER -----
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
                      'Account Number',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.accNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(100),
                      ],
                      hint: "123 456 789 456",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidAccNum.value,
                      suffixWidget: controller.isValidAccNum.value
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
                      validate: controller.validateAccountNumber,
                    )
                  ],
                ),
              ),

              // -------------- CONFIRM ACCOUNT NUMBER -------------
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
                      'Confirm Account Number',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.confirmAccNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(100),
                      ],
                      hint: "123 456 789 456",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidConfirmAccNum.value,
                      suffixWidget: controller.isValidConfirmAccNum.value
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
                      validate: controller.validateConfirmAccNumber,
                    )
                  ],
                ),
              ),

              // -------------- BANK NAME -------------
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
                      'Bank Name',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.bankNameCtrl,
                      hint: "Bank Name",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidBankName.value,
                      suffixWidget: controller.isValidBankName.value
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
                      validate: controller.validateBankName,
                    )
                  ],
                ),
              ),

              // -------------- BANK ROUTING NUMBER -------------
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
                      'Bank Routing Number',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UnderLineInputBox(
                      formkey: controller.formKey,
                      controller: controller.routingNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(100),
                      ],
                      hint: "123 456 789",
                      borderColor: Color(0xFF655AF0),
                      isValid: controller.isValidRoutingNum.value,
                      suffixWidget: controller.isValidRoutingNum.value
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
                      validate: controller.validateRoutingNumber,
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
                        'Add New Bank',
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
