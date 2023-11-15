import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/call_page_controller.dart';

class CallPageView extends GetView<CallPageController> {
  CallPageView({Key? key}) : super(key: key);
  // final controller = Get.put(CallPageController());

  @override
  Widget build(BuildContext context) {
    final _animationDuration = Duration(milliseconds: 600);
    final _animationCurve = Curves.fastOutSlowIn;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetBuilder<CallPageController>(
        init: CallPageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              // title: const Text('CallPageView'),
              // centerTitle: true,
              elevation: 0,
            ),
            body: (controller.agoraClient == null)
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      AgoraVideoViewer(
                        client: controller.agoraClient!,
                        layoutType: Layout.floating,
                        enableHostControls:
                            true, // Add this to enable host controls
                      ),
                      AgoraVideoButtons(
                        client: controller.agoraClient!,
                      ),
                      // Container(
                      //   width: Get.width,
                      //   height: Get.height,
                      //   color: Colors.black,
                      // ),

                      // if (controller.remoteUserUID != null) _remoteUserVideo(),

                      // SHOW LOCAL USER WINDOWS WHEN REMOTE USER JOINED
                      // Obx(
                      //   () => AnimatedPositioned(
                      //     width: controller.remoteUserUID != null
                      //         ? Get.width * 0.3
                      //         : Get.width,
                      //     height: controller.remoteUserUID != null
                      //         ? Get.width * 0.4
                      //         : Get.height,
                      //     top: controller.remoteUserUID != null ? 100.0 : 0.0,
                      //     right: controller.remoteUserUID != null ? 0 : 0.0,
                      //     duration: _animationDuration,
                      //     curve: _animationCurve,
                      //     child: Container(
                      //       decoration: ShapeDecoration(
                      //         color: Colors.transparent,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(
                      //               controller.remoteUserUID != null ? 10 : 0),
                      //           side: BorderSide(
                      //               color: Colors.yellow,
                      //               width: controller.remoteUserUID != null ? 1 : 0),
                      //         ),
                      //       ),
                      //       child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(
                      //               controller.remoteUserUID != null ? 10 : 0),
                      //           child: _localUserVideo()),
                      //     ),
                      //   ),
                      // ),

                      // // BOTTOM ACTION BAR
                      // Positioned(bottom: 20, left: 0, child: _bottomActionBar()),

                      // // CALL INFO PANEL
                      // Positioned(
                      //   bottom: Get.height * 0.2,
                      //   left: 0,
                      //   child: callInfoPanel(),
                      // )
                    ],
                  ),
          );
        });
  }

  //Remote User Video
  Widget _remoteUserVideo() {
    if (controller.remoteUserUID != null) {
      return Stack(
        children: [
          controller.isEnableRemoteVideo
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.rtcEngine!,
                    canvas: VideoCanvas(uid: controller.remoteUserUID),
                    connection: RtcConnection(channelId: controller.channelID),
                  ),
                )
              : Container(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      controller.user?.imageUrl != null
                          ? CircleAvatar(
                              radius: Get.width * 0.15,
                              backgroundColor:
                                  Color.fromARGB(159, 180, 180, 180),
                              backgroundImage: NetworkImage(
                                  '${Network.BASE_URL}${controller.user!.imageUrl}'),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Color.fromARGB(159, 180, 180, 180),
                              backgroundImage:
                                  AssetImage('assets/images/default.png'),
                            ),
                    ],
                  ),
                ),

          // ICONS
          Positioned(
            top: 100,
            left: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: controller.isEnableRemoteVideo
                      ? const Color.fromARGB(161, 158, 158, 158)
                      : Colors.red,
                  child: Icon(
                    controller.isEnableRemoteVideo
                        ? Icons.videocam
                        : Icons.videocam_off,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: controller.isEnableRemoteVideo
                      ? const Color.fromARGB(161, 158, 158, 158)
                      : Colors.red,
                  child: Icon(
                    controller.isEnableRemoteVideo ? Icons.mic : Icons.mic_off,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  // Local User Video
  Widget _localUserVideo() {
    return controller.isLocalUserJoin
        ? controller.isEnableCamera
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: controller.rtcEngine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    controller.user?.imageUrl != null
                        ? CircleAvatar(
                            radius: Get.width * 0.15,
                            backgroundColor: Color.fromARGB(159, 180, 180, 180),
                            backgroundImage: NetworkImage(
                                '${Network.BASE_URL}${controller.user!.imageUrl}'),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: Color.fromARGB(159, 180, 180, 180),
                            backgroundImage:
                                AssetImage('assets/images/default.png'),
                          ),
                  ],
                ),
              )
        : Container(
            width: Get.width,
            height: Get.height,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    child: const CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          );
  }

  // Call Info Panel
  Widget callInfoPanel() {
    return Container(
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${controller.user?.firstName ?? "Criptacy"} ${controller.user?.lastName ?? "User"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 0.07,
              letterSpacing: -0.10,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.2800000011920929),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.05),
              ),
            ),
            child: Text(
              formatTimerTime(controller.estimateTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Bottom Action Button Bar
  Widget _bottomActionBar() {
    return Container(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Sound Button
          actionButton(
              isEnable: controller.isLocalUserJoin,
              icon: Icons.volume_up,
              onTap: () {}),

          // Mic Button
          actionButton(
              isEnable: controller.isEnableMic && controller.isLocalUserJoin,
              icon: controller.isEnableMic ? Icons.mic : Icons.mic_off,
              onTap: () async {
                await controller.onUpdateMic();
              }),

          // SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              // Handle cancel button tap
              controller.onCancelCall();
            },
            child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          // Camera Icon
          actionButton(
              isEnable: controller.isEnableCamera && controller.isLocalUserJoin,
              icon: controller.isEnableCamera
                  ? Icons.videocam
                  : Icons.videocam_off,
              onTap: () async {
                controller.onUpdateCamera();
              }),

          // Change Camera
          actionButton(
              isEnable: true,
              icon: Icons.switch_camera_rounded,
              onTap: () {
                controller.onSwitchCamera();
              }),
        ],
      ),
    );
  }

  Widget actionButton(
      {bool isEnable = true, required IconData icon, required Function onTap}) {
    return InkWell(
      onTap: () {
        return onTap();
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: isEnable
            ? Colors.white
            : Colors.white.withOpacity(0.30000001192092896),
        child: Icon(
          icon,
          size: 26,
          color: isEnable ? LightThemeColors.primaryColor : Colors.white,
        ),
      ),
    );
  }
}
