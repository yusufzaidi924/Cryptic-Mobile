import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/incoming_call_controller.dart';

class IncomingCallView extends GetView<IncomingCallController> {
  IncomingCallView({Key? key}) : super(key: key);
  final controller = Get.put(IncomingCallController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetBuilder<IncomingCallController>(
        init: IncomingCallController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: LightThemeColors.primaryColor,
            // extendBodyBehindAppBar: true,
            // appBar: AppBar(
            // title: const Text('IncomingCallView'),
            // centerTitle: true,
            // elevation: 0,
            // backgroundColor: Colors.transparent,
            // ),
            body: Container(
              width: Get.width,
              padding: const EdgeInsets.only(top: 100, bottom: 50),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [LightThemeColors.primaryColor, Colors.black],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // USER AVATAR
                  Column(
                    children: [
                      controller.user?.imageUrl != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  const Color.fromARGB(159, 159, 157, 241),
                              backgroundImage: NetworkImage(
                                  '${Network.BASE_URL}${controller.user!.imageUrl}'),
                            )
                          : const CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Color.fromARGB(159, 159, 157, 241),
                              backgroundImage:
                                  AssetImage('assets/images/default.png'),
                            ),
                      const SizedBox(height: 16),
                      Text(
                        '${controller.user?.firstName ?? "Criptacy"} ${controller.user?.lastName ?? "User"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Incoming call...',
                        style: TextStyle(
                          color: Color.fromARGB(255, 209, 209, 209),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  // ACTION BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // REJECT
                      InkWell(
                        onTap: () {
                          // Handle cancel button tap
                          controller.onCancelCall();
                        },
                        child: Container(
                          width: 70,
                          height: 70,
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

                      // ACCEPT
                      InkWell(
                        onTap: () {
                          // Handle cancel button tap
                          controller.onAcceptCall();
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
