import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget BackWidget({Function? onTap}) {
  return CupertinoButton(
    onPressed: () {
      if (onTap != null) {
        return onTap();
      } else {
        Get.back();
      }
    },
    padding: const EdgeInsets.all(0),
    child: Container(
      padding: const EdgeInsets.all(0),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: MyColors.primaryButtonColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
