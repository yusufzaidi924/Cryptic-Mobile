import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  SettingPageView({Key? key}) : super(key: key);
  SettingPageController controller = Get.put(SettingPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(builder: (value) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Edit Profile',
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
            icon: Icon(Icons.arrow_back_ios,
                color: LightThemeColors.primaryColor),
          ),
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (BuildContext context) => [
          //       PopupMenuItem(
          //         child: Text('Option 1'),
          //         value: 1,
          //       ),
          //       PopupMenuItem(
          //         child: Text('Option 2'),
          //         value: 2,
          //       ),
          //       PopupMenuItem(
          //         child: Text('Option 3'),
          //         value: 3,
          //       ),
          //     ],
          //     icon: Icon(
          //       Icons.more_vert,
          //       color: Color(0xFF23233F),
          //     ),
          //     onSelected: (value) {
          //       // Handle menu item selection
          //     },
          //   ),
          // ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // --------- AVATAR ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.pickAvatar();
                        },
                        child: controller.avatar.value != null
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(
                                    "${Network.BASE_URL}${controller.avatar.value!}"),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(39, 151, 151, 151),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    AssetImage('assets/images/default.png'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(39, 151, 151, 151),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),

                // ------------ FULL NAME ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Full name',
                      //   style: TextStyle(
                      //     color: Color(0xFF7E7E91),
                      //     fontSize: 14,
                      //     fontFamily: 'DM Sans',
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),

                      // UnderLineInputBox()

                      TextFormField(
                        controller: controller.fullnameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
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
                            controller.validateFullname(value),
                      ),
                    ],
                  ),
                ),

                // ------------ PHONE NUMBER ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Phone number',
                      //   style: TextStyle(
                      //     color: Color(0xFF7E7E91),
                      //     fontSize: 14,
                      //     fontFamily: 'DM Sans',
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      TextFormField(
                        controller: controller.phoneCtrl,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
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
                        // onChanged: (value) =>
                        //     controller.formKey.currentState!.validate(),
                        // validator: (value) => controller.validateFullname(value),
                      ),
                    ],
                  ),
                ),

                // ------------ EMAIL ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Email',
                      //   style: TextStyle(
                      //     color: Color(0xFF7E7E91),
                      //     fontSize: 14,
                      //     fontFamily: 'DM Sans',
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      TextFormField(
                        controller: controller.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
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
                        validator: (value) => controller.validateEmail(value),
                      ),
                    ],
                  ),
                ),

                // -------------- BUTTON ---------------
                InkWell(
                  onTap: () {
                    controller.onSaveChanges();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: ShapeDecoration(
                      color: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Changes',
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
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
