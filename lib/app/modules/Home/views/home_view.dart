import 'package:edmonscan/app/components/bell_widget.dart';
import 'package:edmonscan/app/components/top_menu_item.dart';
import 'package:edmonscan/app/modules/Home/views/bottom_bar_view.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/crypto_util.dart';
import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return GetBuilder<HomeController>(builder: (value) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEFF3),
        body: Column(
          children: [
            //-------- HEADER---------------
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 37),
                  color: Colors.white,
                  child: Container(
                    width: Get.width,
                    height: 185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/home_header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          Builder(builder: (context) {
                            int amount =
                                controller.authCtrl.btcService?.balance ?? 0;
                            double btcAmount =
                                amount / CryptoConf.BITCOIN_DIGIT;
                            return Text(
                              '${btcAmount} BTC',
                              style: const TextStyle(
                                color: Color(0xFFFEBC11),
                                fontSize: 24,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                //---------- NOTIFICATION ICON --------
                Positioned(
                  right: 15,
                  top: 50,
                  child: BellWidget(
                    isShowBadge: true,
                    onTap: () {},
                  ),
                ),

                //---------- REFESH ICON --------
                Positioned(
                  right: 35,
                  top: 45,
                  child: IconButton(
                    onPressed: () async {
                      await controller.initData();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),

                //---------- TOP NAVBAR --------
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: Get.width,
                    height: 74,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: [
                          const BoxShadow(
                            color: Color(0x193D566E),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                            spreadRadius: -2,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // TOP UP
                          topItemMenu(
                            onTap: () {
                              value.goTopUp();
                            },
                            icon: 'assets/images/topup.png',
                            title: "Top up",
                          ),

                          // WALLET
                          topItemMenu(
                            onTap: () {},
                            icon: 'assets/images/wallet.png',
                            title: "Wallet",
                          ),

                          topItemMenu(
                            onTap: () {
                              // Get.toNamed(Routes.MY_Q_R);
                            },
                            icon: 'assets/images/scan.png',
                            title: "QR Scan",
                          ),

                          // My QRCode
                          topItemMenu(
                            onTap: () {
                              Get.toNamed(Routes.MY_Q_R);
                            },
                            icon: 'assets/images/qr.png',
                            title: "My QR",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------- RECENT USERS ---------
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              'Send again',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                height: 0.09,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height:
                                100, // Set the height of the horizontal ListView
                            child: controller.loading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : controller.recentUsers.isEmpty
                                    ? const Center(
                                        child: Text("No Data"),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis
                                            .horizontal, // Set the scroll direction to horizontal
                                        itemCount:
                                            controller.recentUsers.length,
                                        itemBuilder: (context, index) {
                                          return _profileAvatar(
                                              onTap: () {
                                                value.goToProfilePage();
                                              },
                                              avatar: controller
                                                  .recentUsers[index].selfie,
                                              name: controller
                                                      .recentUsers[index]
                                                      .firstName ??
                                                  "Cryptacy User");
                                        },
                                      ),
                          )
                        ],
                      ),
                    ),
                    //------- CURRENCIES ----------
                    Container(
                      height: 250,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 13),
                      color: Colors.white,
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Purchase Currency',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                childAspectRatio:
                                    1.1, // Width to height ratio of grid items
                              ),
                              itemCount: 10, // Number of items in the grid
                              itemBuilder: (context, index) {
                                // Build each grid item
                                return Column(
                                  children: [
                                    Image.asset('assets/images/coin.png'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      'BTC',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF23233F),
                                        fontSize: 14,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 1.0,
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //------- TRANSACTION HISTORY ---------
                    Container(
                      height: 400,
                      color: Colors.white,
                      // margin: EdgeInsets.symmetric(vertical: 15),
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.20,
                                child: Container(
                                  width: 80,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFDDDDDD)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Transaction History',
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: controller.loading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : controller.authCtrl.btcService!
                                          .transactionList.isEmpty
                                      ? const Center(
                                          child: Text("No Transactions"),
                                        )
                                      : ListView.separated(
                                          itemCount: controller
                                              .authCtrl
                                              .btcService!
                                              .transactionList
                                              .length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            final trans = controller
                                                .authCtrl
                                                .btcService!
                                                .transactionList[index];
                                            // Logger().d(trans.txid );
                                            return Row(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const ShapeDecoration(
                                                    shape: OvalBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Color(
                                                              0xFF655AF0)),
                                                    ),
                                                  ),
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/coin.png'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    // mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              '${trans.txid} ',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF23233F),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'DM Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .onViewTransaction(
                                                                      trans
                                                                          .txid);
                                                            },
                                                            child: Icon(
                                                                Icons.ios_share,
                                                                color: LightThemeColors
                                                                    .primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 13,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Builder(builder:
                                                              (context) {
                                                            int amount =
                                                                trans.received -
                                                                    trans.sent;
                                                            double btc =
                                                                CryptoUtil
                                                                    .satoToBtc(
                                                                        amount);
                                                            return Text(
                                                              '${btc}',
                                                              style: TextStyle(
                                                                color: btc > 0
                                                                    ? Colors
                                                                        .green
                                                                    : const Color(
                                                                        0xFFEB5A5A),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'DM Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.0,
                                                              ),
                                                            );
                                                          }),
                                                          Text(
                                                            trans.confirmationTime ==
                                                                    null
                                                                ? "Just Now"
                                                                : timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(
                                                                    (trans.confirmationTime!.timestamp *
                                                                            1000)
                                                                        .toInt())),
                                                            textAlign:
                                                                TextAlign.right,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF6E6E82),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'DM Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.0,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Divider(
                                                height:
                                                    1, // Set the height of the separator
                                                color: Colors
                                                    .grey, // Set the color of the separator
                                              ),
                                            );
                                          },
                                        ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomBarView(),
      );
    });
  }

  _profileAvatar(
      {required Function onTap, String? avatar, required String name}) {
    return InkWell(
      onTap: () {
        return onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: const ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(width: 1, color: Color(0xFF655AF0)),
                ),
              ),
              child: avatar == null
                  ? const CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/images/default.png'),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(avatar),
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${name}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                color: Color(0xFF23233F),
                fontSize: 14,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
