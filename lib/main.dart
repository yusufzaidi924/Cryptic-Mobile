import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/services/awesome_notifications_helper.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';

import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'firebase_options.dart';
import 'utils/constants.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // init shared preference
  await MySharedPref.init();

  await Firebase.initializeApp(
    name: "EdMonScan",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());

  // inti fcm services
  await FcmHelper.initFcm();

  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  runApp(
    ScreenUtilInit(
      // todo add your (Xd / Figma) artboard size
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          // todo add your app name
          title: "EdMon Scan",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          theme: MyTheme.getThemeData(isLight: true),
          builder: EasyLoading.init(),
          initialRoute: FirebaseAuth.instance.currentUser != null
              ? Routes.PROJECTS_PAGE
              // ? Routes.WELCOME
              : AppPages.INITIAL, // first screen to show when app is running
          getPages: AppPages.routes, // app screens
          locale: MySharedPref.getCurrentLocal(), // app language
          translations: LocalizationService
              .getInstance(), // localization services in app (controller app language)
        );
      },
    ),
  );

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    ..radius = 10.0
    // ..progressColor = Colors.yellow
    ..backgroundColor = MyColors.backgroundColor1
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    // ..maskColor = Colors.red
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
