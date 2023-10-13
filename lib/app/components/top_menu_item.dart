import 'package:flutter/material.dart';

Widget topItemMenu(
    {required String icon, required String title, required Function onTap}) {
  return Expanded(
    child: InkWell(
      onTap: () {
        return onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 26,
            height: 26,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF23233F),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          )
        ],
      ),
    ),
  );
}
