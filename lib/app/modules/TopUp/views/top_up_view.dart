import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/top_up_controller.dart';

class TopUpView extends GetView<TopUpController> {
  TopUpView({Key? key}) : super(key: key);

  TopUpController controller = Get.put(TopUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopUpController>(builder: (value) {
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
            'Top Up',
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
              //---------- POPULAR AMOUNTS -------------
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: Get.width,
                color: Colors.white,
                child: Column(
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
              InkWell(
                onTap: () {
                  value.goMyPaymentMethod();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 13),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: Get.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFEBC11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Icon(
                              Icons.wallet_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'VISA',
                                  style: TextStyle(
                                    color: Color(0xFF23233F),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '*6874',
                                  style: TextStyle(
                                    color: Color(0xFF6E6E82),
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '(Switch Account)',
                        style: TextStyle(
                          color: Color(0xFF3E397D),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 0.10,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //------------ POLICY & BUTTON --------
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: Get.width,
                color: Color(0xFFEEEFF3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree with the ',
                                style: TextStyle(
                                  color: Color(0xFF23233F),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms and conditions.',
                                style: TextStyle(
                                  color: Color(0xFF655AF0),
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        // SizedBox(
                        //   wid, th: 10,
                        // ),
                        Expanded(
                          child: Text(
                            'I understand that all transfers are final once sent and can not be reversed, cancelled or refunded.',
                            style: TextStyle(
                              color: Color(0xFF23233F),
                              fontSize: 13,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                        )
                      ],
                    ),

                    //---------- BUTTON ------
                    Container(
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
                            'SWIPE TO TOP UP',
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
