import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/withdraw_page_controller.dart';

class WithdrawPageView extends GetView<WithdrawPageController> {
  WithdrawPageView({Key? key}) : super(key: key);
  WithdrawPageController controller = Get.put(WithdrawPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawPageController>(builder: (value) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: LightThemeColors.primaryColor,
            ),
          ),
          title: Text(
            'Withdraw',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ---------- BANK SELECT ----------------
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Withdraw to Chase Bank',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    '*8784',
                    style: TextStyle(
                      color: Color(0xFF6E6E82),
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              //---------- POPULAR AMOUNTS -------------
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: Get.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Popular Amounts',
                      style: TextStyle(
                        color: Color(0xFF23233F),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: double.infinity,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.9,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                          controller.priceList.length,
                          (index) => InkWell(
                            onTap: () {
                              controller.selectPrice(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0x19655AF0),
                                borderRadius: BorderRadius.circular(15),
                                border: index ==
                                        controller.selectedPriceIndex.value
                                    ? Border.all(
                                        color: LightThemeColors.primaryColor,
                                        width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '\$${controller.priceList[index]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF23233F),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //---------- AMOUNT INPUT --------------
              Container(
                margin: EdgeInsets.only(bottom: 13),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: Get.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Cash ',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '(Current Balance: ',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '\$12,769.00',
                              style: TextStyle(
                                color: Color(0xFF655AF0),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ')',
                              style: TextStyle(
                                color: Color(0xFF23233F),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    TextField(
                      controller: controller.amountController,
                      decoration: InputDecoration(
                        prefix: Text('\$'),
                        labelText: 'Enter amount',
                        labelStyle: TextStyle(
                          color: LightThemeColors.primaryColor,
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: LightThemeColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //----------- PAYMENT METHOD -----------
              //------------ POLICY & BUTTON --------
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: Get.width,
                color: Color(0xFFEEEFF3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //---------- BUTTON ------
                    InkWell(
                      onTap: () {
                        value.withdraw();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: LightThemeColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(children: [
                          Container(
                            width: 50,
                            height: 54,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: LightThemeColors.primaryColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'SWIPE TO WITHDRAW',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
