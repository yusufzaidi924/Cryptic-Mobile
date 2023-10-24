import 'package:edmonscan/app/components/underLine_input.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/transfer_page_controller.dart';

class TransferPageView extends GetView<TransferPageController> {
  TransferPageView({Key? key}) : super(key: key);
  TransferPageController controller = Get.put(TransferPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferPageController>(builder: (value) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEFF3),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Send Balance',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23233F),
              fontSize: 24,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF23233F),
            ),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  child: Text('Option 1'),
                  value: 1,
                ),
                const PopupMenuItem(
                  child: Text('Option 2'),
                  value: 2,
                ),
                const PopupMenuItem(
                  child: Text('Option 3'),
                  value: 3,
                ),
              ],
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF23233F),
              ),
              onSelected: (value) {
                // Handle menu item selection
              },
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // --------- USER INFO ------

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  width: Get.width,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: DropdownButton<UserModel>(
                    isExpanded: true,
                    value: controller.selectedUser,
                    itemHeight: 60,
                    onChanged: (UserModel? userModel) {
                      controller.updateSelectedUser(userModel!);
                    },
                    items: controller.users.map((user) {
                      return DropdownMenuItem<UserModel>(
                        value: user,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              user.selfie != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          '${Network.BASE_URL}${user.selfie}'),
                                      radius: 28,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/default.png',
                                      ),
                                      radius: 28,
                                    ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    user.phone,
                                    style: const TextStyle(
                                      color: Color(0xFF6E6E82),
                                      fontSize: 14,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ------------ SELECT CURRENCY ------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose your currency',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: 'Bitcoin',
                        onChanged: (String? string) {},
                        style: const TextStyle(
                          fontSize: 16, // Customize the font size
                          color: Colors.blue, // Customize the text color
                          fontWeight:
                              FontWeight.bold, // Customize the font weight
                        ),
                        items: ['Bitcoin'].map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize:
                                    14, // Customize the font size of the dropdown menu items
                                color: Colors
                                    .black, // Customize the text color of the dropdown menu items
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      // UnderLineInputBox(
                      //     formkey: formkey,
                      //     controller: controller,
                      //     hint: hint,
                      //     validate: validate)
                    ],
                  ),
                ),

                //---------- AMOUNT INPUT --------------
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: Get.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        int amount =
                            controller.authCtrl.btcService?.balance ?? 0;
                        double btcAmount = amount / CryptoConf.BITCOIN_DIGIT;
                        return Container(
                          width: double.infinity,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Amount ',
                                  style: TextStyle(
                                    color: Color(0xFF23233F),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: '(Balance: ',
                                  style: TextStyle(
                                    color: Color(0xFF23233F),
                                    fontSize: 16,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '${btcAmount} BTC',
                                  style: const TextStyle(
                                    color: Color(0xFF655AF0),
                                    fontSize: 16,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const TextSpan(
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
                        );
                      }),
                      // SizedBox(height: 10),
                      TextFormField(
                        controller: controller.amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefix: Text('\$'),
                          labelText: 'Enter amount',
                          labelStyle: TextStyle(
                            color: LightThemeColors.primaryColor,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.formKey.currentState!.validate(),
                        validator: (value) => controller.validateAmount(value),
                      ),
                    ],
                  ),
                ),

                //------------- GREETING OPTION---------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Include a Greeting *(optional)',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 100,
                        width: Get.width,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int indext) {
                            return Container(
                              width: 90,
                              height: 80,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEB5A5A).withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset(
                                  'assets/images/greeting_avatar.png'),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 15);
                          },
                        ),
                      )
                    ],
                  ),
                ),

                //------------- MESSAGE -------
                Container(
                  width: Get.width,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a message (Limit 120 Characters)',
                        style: TextStyle(
                          color: Color(0xFF23233F),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: controller.messageCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Enter your message here',
                          labelStyle: TextStyle(
                            color: LightThemeColors.primaryColor,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: LightThemeColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.formKey.currentState!.validate(),
                        validator: (value) => controller.validateMessage(value),
                      ),
                    ],
                  ),
                ),

                // -------------- BUTTON ---------------
                InkWell(
                  onTap: () {
                    value.onTransfer();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    decoration: ShapeDecoration(
                      color: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 54,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: LightThemeColors.primaryColor,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'SWIPE TO TRANSFER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
