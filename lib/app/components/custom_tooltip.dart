import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  CustomTooltip({required this.message, required this.child});

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  bool _showTooltip = false;

  void _toggleTooltip() {
    setState(() {
      _showTooltip = !_showTooltip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleTooltip,
      child: Stack(
        children: [
          widget.child,
          if (_showTooltip)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
