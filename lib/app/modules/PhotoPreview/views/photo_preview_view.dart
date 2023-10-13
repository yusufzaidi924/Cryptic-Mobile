import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/photo_preview_controller.dart';

class PhotoPreviewView extends GetView<PhotoPreviewController> {
  const PhotoPreviewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoPreviewView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PhotoPreviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
