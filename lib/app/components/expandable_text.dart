import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle buttonStyles;

  const ExpandableText(
      {super.key,
      required this.text,
      required this.maxLines,
      required this.buttonStyles});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text ?? "No Details",
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (widget.text != null && widget.text.isNotEmpty)
          GestureDetector(
            child: Text(
              isExpanded ? 'Read less' : 'Read more',
              style: widget.buttonStyles,
            ),
            onTap: () {
              setState(
                () {
                  isExpanded = !isExpanded;
                },
              );
            },
          ),
      ],
    );
  }
}
