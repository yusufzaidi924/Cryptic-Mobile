import 'package:flutter/material.dart';

class AppStyles {
  static String? fontFamily;
  static List<Shadow> blackShadow({double opacity = 0.3}) {
    return [
      Shadow(
        color: Colors.black.withOpacity(opacity),
        offset: Offset(1, 2),
        blurRadius: 10,
      )
    ];
  }

  static TextStyle textSize8(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 8,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize9(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 9,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize10(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 10,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize11(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 11,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize12(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 12,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize13(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 13,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize14(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize15(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 15,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize16(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 16,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize17(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 17,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize18(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 18,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize19(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 19,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize20(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 20,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize24(
      {Color? color, FontWeight fontWeight = FontWeight.w600, context}) {
    // var _context =
    //     NavigationService.instance.navigationKey!.currentState!.context;
    // return Theme.of(_context).textTheme.displayMedium!.copyWith(
    //       fontSize: 24,
    //       fontWeight: fontWeight,
    //       fontFamily: fontFamily,
    //     );
    // return Theme.of(context!).textTheme.displayMedium!.copyWith(
    //       fontSize: 24,
    //       fontWeight: fontWeight,
    //       fontFamily: fontFamily,
    //       decoration: TextDecoration.none,
    //     );
    return TextStyle(
      fontSize: 24,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize25(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 25,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize26(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 26,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize30(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 30,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize31(
      {Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: 31,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textSize32(
      {Color? color, FontWeight fontWeight = FontWeight.w700}) {
    return TextStyle(
      fontSize: 32,
      color: color ?? Colors.black,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }
}
