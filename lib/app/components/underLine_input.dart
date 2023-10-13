import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget UnderLineInputBox({
  required GlobalKey<FormState> formkey,
  required TextEditingController controller,
  required String hint,
  required Function validate,
  bool? isValid,
  TextInputType? keyboardType,
  bool? isSecure,
  Widget? suffixWidget,
  Color? fillColor,
  Color? borderColor,
  Color? textColor,
  Color? hintColor,
}) {
  return Container(
    width: double.infinity,
    // height: 70,
    child: TextFormField(
      controller: controller,
      obscureText: isSecure ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      // maxLength: 100,
      style: TextStyle(
        color: textColor ?? LightThemeColors.bodyTextColor,
        fontSize: 14,
      ),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: hintColor ?? Colors.grey,
          fontSize: 14,
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 10, 20, 15),
        isDense: true,
        suffixIcon: suffixWidget != null
            ? suffixWidget
            : isValid != null && isValid
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
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
            width: isValid != null && isValid ? 2 : 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
            width: isValid != null && isValid ? 2 : 1,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
      onChanged: (value) {
        formkey.currentState!.validate();
      },
      validator: (value) {
        return validate(value);
      },
    ),
  );
}
