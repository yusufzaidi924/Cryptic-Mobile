import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/account_security_controller.dart';

class AccountSecurityView extends GetView<AccountSecurityController> {
  AccountSecurityView({Key? key}) : super(key: key);
  AccountSecurityController controller = Get.put(AccountSecurityController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountSecurityController>(builder: (value) {
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
            'Account Security',
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
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // ------------ CURRENT PASSWORD ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.oldPassCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter Current Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF7E7E91),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.formKey.currentState!.validate(),
                        validator: (value) => controller.validatePass(value),
                      ),
                    ],
                  ),
                ),

                // ------------ NEW PASSWORD ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.newPassCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter New Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF7E7E91),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.formKey.currentState!.validate(),
                        validator: (value) => controller.validatePass(value),
                      ),
                    ],
                  ),
                ),

                // ---------- CONFIRM PASSWORD -----------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.confirmPassCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: TextStyle(
                            color: Color(0xFF7E7E91),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.formKey.currentState!.validate(),
                        validator: (value) =>
                            controller.validateConfirmPass(value),
                      ),
                    ],
                  ),
                ),

                // --------------UPDATE PASSWORD BUTTON ---------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  margin:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: ShapeDecoration(
                    color: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      controller.onUpdatePassword();
                    },
                    child: Container(
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Update Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //-------------- DELETE ACCOUNT BUTTON ---------------------
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delete Account?',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Form(
                        key: controller.deleteFormKey,
                        child: TextFormField(
                          controller: controller.deleteTextCtrl,
                          decoration: const InputDecoration(
                            // labelText: 'Please',
                            hintStyle: TextStyle(
                              color: Color(0xFF7E7E91),
                            ),
                            hintText: 'Please type "DELETE ACCOUNT"',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LightThemeColors.primaryColor),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LightThemeColors.primaryColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LightThemeColors.primaryColor),
                            ),
                          ),
                          onChanged: (value) =>
                              controller.deleteFormKey.currentState!.validate(),
                          validator: (value) =>
                              controller.validateDeleteText(value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: InkWell(
                          onTap: () {
                            controller.onDeleteAccount();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color.fromARGB(255, 205, 0, 7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'DELETE MY ACCOUNT',
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
                      ),
                      const Text(
                        'WARNING: DELETING YOUR ACCOUNT IS PERMANENT AND IRREVERSIBLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
