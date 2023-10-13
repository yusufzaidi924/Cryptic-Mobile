import 'dart:ui';

import 'package:edmonscan/app/modules/Home/controllers/home_controller.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';

class BottomBarView extends GetView {
  BottomBarView({Key? key}) : super(key: key);
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // final subscribeCtl = Get.find<SubscriptionController>();
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x193D566E),
            blurRadius: 12,
            offset: Offset(0, -4),
            spreadRadius: -2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: GetBuilder<HomeController>(builder: (_) {
          return BottomNavigationBar(
            onTap: controller.updateBottombarIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.home,
                ),
                label: ".",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/transfer_icon.png'),
                label: ".",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/trans_his_icon.png'),
                // Icon(
                //   Ionicons.ios_location_outline,
                // ),
                label: ".",
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outlined,
                  size: 28,
                ),
                label: ".",
              ),
            ],
            currentIndex: controller.selectedInex.value, // selectedIndex,
            showUnselectedLabels: false,
            selectedItemColor: LightThemeColors.primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            selectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            // fixedColor: white,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          );
        }),
      ),
    );
  }
}
