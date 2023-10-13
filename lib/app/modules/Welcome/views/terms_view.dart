import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
// import 'package:edmonscan/app/modules/Home/views/home_view.dart';
import 'package:edmonscan/app/modules/Welcome/views/welcome_view.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsView extends StatefulWidget {
  const TermsView({Key? key, required this.isFirst}) : super(key: key);
  final bool isFirst;
  @override
  _TermsViewState createState() => _TermsViewState();
}

class _TermsViewState extends State<TermsView> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Use'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SfPdfViewer.asset('assets/doc/terms.pdf')),
          ),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              Text('Agree to the terms'),
            ],
          ),
          SizedBox(
            width: Get.width,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> saveData = {};
                  if (_isChecked) {
                    // final user = AuthController.authUser.value;
                    // if (user!.metadata?[PrivacySettingKey.COLLECTION] == null) {
                    //   Logger().e("Terms agree Null");
                    //   saveData = {
                    //     'metadata.${PrivacySettingKey.COLLECTION}': {
                    //       '${PrivacySettingKey.AGREE_TERMS}': true
                    //     }
                    //   };
                    // } else {
                    //   Logger().e("Terms agree Value");

                    //   saveData = {
                    //     'metadata.${PrivacySettingKey.COLLECTION}.${PrivacySettingKey.AGREE_TERMS}':
                    //         true
                    //   };
                    // }

                    // await FirebaseFirestore.instance
                    //     .collection(DatabaseConfig.USER_COLLECTION)
                    //     .doc(FirebaseAuth.instance.currentUser!.uid)
                    //     .update(saveData);
                    // if (widget.isFirst) {
                    //   Get.to(() => WelcomeView());
                    // } else {
                    //   Get.to(() => HomeView());
                    // }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isChecked ? MyColors.primaryButtonColor : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
