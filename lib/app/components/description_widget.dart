import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? moreTextStyle;
  final int? initLength;
  final String? moreText;
  final String? lessText;

  DescriptionTextWidget({
    required this.text,
    this.textStyle,
    this.moreTextStyle,
    this.initLength = 50,
    this.moreText = "Read More",
    this.lessText = "Show less",
  });

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf = "";
  String secondHalf = "";

  bool flag = true;

  @override
  void initState() {
    super.initState();
    int length = widget.initLength ?? 50;
    if (widget.text.length > length) {
      firstHalf = widget.text.substring(0, length);
      secondHalf = widget.text.substring(length, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String descText = secondHalf.isEmpty
        ? firstHalf
        : flag
            ? firstHalf + "..."
            : firstHalf + secondHalf;
    Widget descTextWidget = widget.textStyle != null
        ? Text(
            descText,
            style: widget.textStyle,
          )
        : Text(descText);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? descTextWidget
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                descTextWidget,
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? widget.moreText! : widget.lessText!,
                        style: widget.moreTextStyle != null
                            ? widget.moreTextStyle
                            : TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
