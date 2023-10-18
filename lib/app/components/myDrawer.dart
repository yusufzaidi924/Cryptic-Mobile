import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget myDrawer() {
  final user = FirebaseAuth.instance.currentUser;
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: user?.photoURL == null
                  ? Image.asset("assets/images/avatar.png")
                  : Image.network(user!.photoURL!)),
          decoration: BoxDecoration(
            color: MyColors.backgroundColor1,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: MyColors.white,
          ),
          title: Text(
            'Settings',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: MyColors.primaryButtonColor),
          ),
          onTap: () {
            // Handle option 2 press
          },
        ),
        GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return ListTile(
                leading: Icon(
                  Icons.logout,
                  color: MyColors.white,
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                      color: MyColors.yellowButtonColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
                onTap: () {
                  // Handle option 1 press
                  // controller.signOut();
                },
              );
            }),
      ],
    ),
  );
}
