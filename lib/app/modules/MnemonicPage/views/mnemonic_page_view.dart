import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/mnemonic_page_controller.dart';

class MnemonicPageView extends GetView<MnemonicPageController> {
  MnemonicPageView({Key? key}) : super(key: key);
  final controller = Get.put(MnemonicPageController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return GetBuilder<MnemonicPageController>(builder: (controller) {
      return Scaffold(
        backgroundColor: LightThemeColors.primaryColor,
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/blue_back.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),

                //--------- SHARE ICON -------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/upload_icon.png'),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                //--------- ALERT BOX ---------
                Stack(
                  children: [
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(
                        // left: 20,
                        // right: 20,
                        top: 25,
                        bottom: 25,
                      ),
                      child: Container(
                        width: Get.width,
                        // height: 500,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Text(
                                'MNEMONIC CODES',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF23233F),
                                  fontSize: 24,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Please remember to securely store your mnemonic code and private key',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF6E6E82),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // SizedBox(
                            //   height: 30,
                            // ),

                            ///////////////////////////// MNEMONIC & PRIVATE KEY PART ///////////////////////

                            controller.loading.value
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 10,
                                          childAspectRatio:
                                              Get.width * 0.5 / 60,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: 12,
                                        itemBuilder: (context, index) {
                                          final controller =
                                              TextEditingController(
                                                  text: 'Default value');
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                                child: Text(
                                                  '${index + 1}.',
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                              // SizedBox(width: 8),
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: LightThemeColors
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextField(
                                                    controller: controller,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      // Add more text style properties as needed
                                                    ),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      enabled: false,
                                                      hintText:
                                                          'Seed word ${index + 1}',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF655AF0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: Get.width / 2 - 75,
                      top: 0,
                      child: Container(
                        width: 150,
                        height: 64,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 41,
                              top: 0,
                              child: Container(
                                width: 64,
                                height: 64,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 64,
                                        height: 64,
                                        decoration: const ShapeDecoration(
                                          color: Colors.white,
                                          shape: OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  111, 104, 104, 104),
                                              blurRadius: 20,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 8,
                                      top: 8,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFF3DAB24),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 20,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(),
                                        child: const Stack(children: [
                                          Icon(
                                            Icons.key,
                                            color: Colors.white,
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 23,
                              child: Container(
                                width: 149,
                                height: 37,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 143,
                                      top: 20,
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFF3DAB24),
                                          shape: OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  111, 104, 104, 104),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 114,
                                      top: 0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFF3DAB24),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                                width: 3, color: Colors.white),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  111, 104, 104, 104),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 19,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFF3DAB24),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                                width: 3, color: Colors.white),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  111, 104, 104, 104),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
