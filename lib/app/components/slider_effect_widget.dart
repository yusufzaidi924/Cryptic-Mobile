import 'package:edmonscan/app/components/creditCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliderEffect extends StatefulWidget {
  SliderEffect({
    super.key,
    required this.child,
    required this.onDelete,
    this.spaceWidth,
    this.width,
    this.height,
    this.padding,
  });
  final double? width;
  final double? height;
  final double? spaceWidth;
  final double? padding;
  final Widget child;
  final Function onDelete;
  @override
  State<SliderEffect> createState() => _SliderEffectState();
}

class _SliderEffectState extends State<SliderEffect> {
  bool _isCardPressed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double space = widget.spaceWidth ?? 25;
    double hPadding = widget.padding ?? 15;
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isCardPressed = true;
        });
      },
      onTap: () {
        if (_isCardPressed) {
          setState(() {
            _isCardPressed = false;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            width: widget.width ?? Get.width,
            height: widget.height,
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 1),
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xFFEB5A5A).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      return widget.onDelete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: _isCardPressed ? -space : hPadding,
            width: Get.width - 2 * hPadding,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
