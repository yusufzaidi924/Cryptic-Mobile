import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final String path;
  final bool isNetwork;
  const ImagePreviewPage(
      {Key? key, required this.path, required this.isNetwork})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: 'imageTag',
            child: isNetwork ? Image.network(path) : Image.file(File(path)),
          ),
        ),
      ),
    );
  }
}
