import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget SocialCircleButton(
    {required double radius,
    required Color backgroundColor,
    Color? borderColor,
    required Widget icon}) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(width: 1, color: borderColor ?? Colors.transparent),
        color: backgroundColor),
    child: icon,
  );
}
