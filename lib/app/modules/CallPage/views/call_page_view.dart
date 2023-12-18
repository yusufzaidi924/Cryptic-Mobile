import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/app_assets.dart';
import 'package:edmonscan/utils/app_styles.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              extendBody: true,
              bottomNavigationBar: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17)),
                child: controller.agoraClient == null
                    ? null
                    : BottomNavigationBar(
                        backgroundColor: Colors.black,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: 0,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        onTap: (value) {
                          switch (value) {
                            case 0:
                              controller.muteAudio();
                              break;
                            case 1:
                              controller.muteMicro();
                              break;
                            case 2:
                              break;
                            case 3:
                              controller.turnOffCamera();
                              break;
                            case 4:
                              controller.changeCamera();
                              break;
                          }
                        },
                        items: [
                            BottomNavigationBarItem(
                                label: "",
                                icon: ActionIcon(
                                    isOn: controller.speakerOn,
                                    icon: AppAssets.speakerIcon,
                                    onTap: () async {}),
                                backgroundColor: Colors.black),
                            BottomNavigationBarItem(
                              label: "",
                              icon: ActionIcon(
                                  isOn: controller.microOn,
                                  icon: AppAssets.microIcon,
                                  onTap: () async {}),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Container(),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: ActionIcon(
                                  isOn: controller.cameraOn,
                                  icon: AppAssets.videoIcon,
                                  onTap: () async {}),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: ActionIcon(
                                  isOn: controller.isFrontCamera,
                                  icon: AppAssets.rotateIcon,
                                  onTap: () {}),
                            ),
                          ]),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: GestureDetector(
                onTap: () {
                  controller.onCancelCall();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: LightThemeColors.primaryColor,
                  ),
                  child: Center(child: SvgPicture.asset(AppAssets.callEndIcon)),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 37, 33, 31),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                // title: const Text('CallPageView'),
                // centerTitle: true,
                elevation: 0,
              ),
              body: Builder(builder: (_) {
                if (controller.connecting || controller.agoraClient == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Network.BASE_URL}${controller.user!.imageUrl}",
                            width: 90,
                            height: 90,
                            errorWidget: (context, url, error) {
                              return Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 40,
                                  ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            getUserName(controller.user),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "Connecting...",
                            style: AppStyles.textSize16(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Stack(
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
                    // Positioned(bottom: 0, child: CallActionButtons()),
                    // AgoraVideoButtons(
                    //   client: controller.agoraClient!,
                    //   onDisconnect: () {
                    //     controller.onCancelCall();
                    //   },
                    // ),
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
                );
              }));
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
          if (controller.timer == null)
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
                "Rinning...",
                style: AppStyles.textSize14(
                  color: Colors.white,
                ),
              ),
            ),
          if (controller.estimateTime > 0)
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

class ActionIcon extends StatelessWidget {
  final bool isOn;
  final String icon;
  final Function() onTap;
  const ActionIcon(
      {super.key, required this.isOn, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? Colors.white : Colors.white.withOpacity(0.3),
      ),
      child: Center(
          child: SvgPicture.asset(
        icon,
        color: isOn ? Colors.black : Colors.white,
      )),
    );
  }
}
