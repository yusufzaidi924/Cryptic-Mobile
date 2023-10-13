import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BellWidget extends StatelessWidget {
  BellWidget({super.key, required this.onTap, required this.isShowBadge});
  final Function onTap;
  final bool isShowBadge;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return onTap();
      },
      child: Stack(
        children: [
          Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
          if (isShowBadge)
            Positioned(
              top: 5,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: ShapeDecoration(
                  color: Color(0xFFFEBC11),
                  shape: OvalBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
