import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
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
    final _animationDuration = const Duration(milliseconds: 600);
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
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      AgoraVideoViewer(
                        client: controller.agoraClient!,
                        layoutType: Layout.oneToOne,

                        disabledVideoWidget: _localUserDisableVideo(),
                        showAVState: true,
                        showNumberOfUsers: true,
                        enableHostControls:
                            true, // Add this to enable host controls
                      ),
                      AgoraVideoButtons(
                        client: controller.agoraClient!,
                        onDisconnect: () {
                          controller.onCancelCall();
                        },
                      ),
                      // Container(
                      //   width: Get.width,
                      //   height: Get.height,
                      //   color: Colors.black,
                      // ),

                      // if (controller.remoteUserUID != null) _remoteUserVideo(),

                      // CALL INFO PANEL
                      Positioned(
                        bottom: Get.height * 0.2,
                        left: 0,
                        child: callInfoPanel(),
                      )
                    ],
                  ),
          );
        });
  }

  // Local User Video
  Widget _localUserDisableVideo() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 150,
          ),
          controller.user?.imageUrl != null
              ? CircleAvatar(
                  radius: Get.width * 0.15,
                  backgroundColor: const Color.fromARGB(159, 180, 180, 180),
                  backgroundImage: NetworkImage(
                      '${Network.BASE_URL}${controller.user!.imageUrl}'),
                )
              : const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(159, 180, 180, 180),
                  backgroundImage: AssetImage('assets/images/default.png'),
                ),
        ],
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
            getUserName(controller.user),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.2800000011920929),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.05),
              ),
            ),
            child: Text(
              formatTimerTime(controller.estimateTime),
              style: const TextStyle(
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
}
