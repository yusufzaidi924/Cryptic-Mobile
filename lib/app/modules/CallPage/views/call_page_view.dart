import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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
            body: Stack(
              children: [
                controller.remoteUserUID != null
                    ? _remoteUserVideo()
                    : _localUserVideo(),

                // SHOW LOCAL USER WINDOWS WHEN REMOTE USER JOINED
                Positioned(
                  top: 100,
                  right: 0,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.yellow, width: 1),
                      ),
                    ),
                    width: Get.width * 0.3,
                    height: Get.width * 0.4,
                    child: _localUserVideo(),
                  ),
                ),

                // BOTTOM ACTION BAR
                Positioned(bottom: 20, left: 0, child: _bottomActionBar()),

                // CALL INFO PANEL
                Positioned(
                  bottom: Get.height * 0.2,
                  left: 0,
                  child: callInfoPanel(),
                )

                // Container(
                //     width: Get.width,
                //     padding: EdgeInsets.only(top: 100, bottom: 50),
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           LightThemeColors.primaryColor,
                //           Colors.black
                //         ],
                //       ),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         // USER AVATAR
                //         Column(
                //           children: [
                //             controller.user?.imageUrl != null
                //                 ? CircleAvatar(
                //                     radius: 60,
                //                     backgroundColor:
                //                         Color.fromARGB(159, 159, 157, 241),
                //                     backgroundImage: NetworkImage(
                //                         '${Network.BASE_URL}${controller.user!.imageUrl}'),
                //                   )
                //                 : CircleAvatar(
                //                     radius: 60,
                //                     backgroundColor:
                //                         Color.fromARGB(159, 159, 157, 241),
                //                     backgroundImage: AssetImage(
                //                         'assets/images/default.png'),
                //                   ),
                //             SizedBox(height: 16),
                //             Text(
                //               '${controller.user?.firstName ?? "Criptacy"} ${controller.user?.lastName ?? "User"}',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 24,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 30,
                //             ),
                //             Text(
                //               'Calling...',
                //               style: TextStyle(
                //                 color: const Color.fromARGB(
                //                     255, 209, 209, 209),
                //                 fontSize: 18,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          );
        });
  }

  //Remote User Video
  Widget _remoteUserVideo() {
    if (controller.remoteUserUID != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.rtcEngine!,
          canvas: VideoCanvas(uid: controller.remoteUserUID),
          connection: RtcConnection(channelId: controller.channelID),
        ),
      );
    } else {
      return Container();
    }
  }

  // Local User Video
  Widget _localUserVideo() {
    return controller.isLocalUserJoin
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.rtcEngine!,
              canvas: const VideoCanvas(uid: 0),
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
                controller.onUpdateMic();
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
              isEnable:
                  controller.isEnableSwitchCam && controller.isLocalUserJoin,
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
