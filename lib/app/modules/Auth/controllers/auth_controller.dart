// import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/data/models/UserModal.dart';
import 'package:edmonscan/app/modules/Auth/views/sign_in_view.dart';
import 'package:edmonscan/app/modules/ProjectsPage/views/projects_page_view.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/local_storage.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/local/my_shared_pref.dart';

// import 'package:edmonscan/app/modules/Home/views/home_view.dart';
import 'package:edmonscan/app/modules/Welcome/views/terms_view.dart';
import 'package:edmonscan/app/modules/Welcome/views/welcome_view.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController
  AuthController();
  final count = 0.obs;

  final _userModel = Rxn<UserModel>();
  UserModel? get authUser => _userModel.value;

  // ========= SignIn ========================
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final phoneNumber = "".obs;
  final isValidPhoneNumber = false.obs;
  String countryCode = "US";
  final isValidLoginPass = false.obs;
  final isSavePass = false.obs;

  bool isSignInFlow = true;

  /***********************
   * Update SavePass Check
   */
  updateCheckPass(bool value) {
    isSavePass.value = value;
    update();
  }

  /***********************
   * Validate Phone Number
   */
  String? validatePhoneNumber(PhoneNumber? number) {
    try {
      if (number != null) {
        isValidPhoneNumber.value = number.isValidNumber();
      } else {
        isValidPhoneNumber.value = false;
      }
    } catch (e) {
      isValidPhoneNumber.value = false;
    }

    update();
    return isValidPhoneNumber.value ? null : "Invalid Mobile Number";
  }

  /*********************
   * Update Phone Number
   */
  void updatePhoneNumber(PhoneNumber? number) {
    phoneNumber.value = number?.completeNumber ?? "";
    validatePhoneNumber(number);
    update();
  }

  /************************
   * Validate Password 
   */
  String? validateLoginPass(String? value) {
    String? res = null;
    isValidLoginPass.value = false;
    if (value != null) {
      if (value.length < 8) {
        isValidLoginPass.value = false;
        res = 'Password should be at least 8 characters';
      } else if (value.length > 30) {
        isValidLoginPass.value = false;
        res = 'Password should be less than 30 characters';
      } else if (value.isEmpty) {
        isValidLoginPass.value = false;
        res = 'Password is required.';
      } else {
        isValidLoginPass.value = true;
        res = null;
      }
    } else {
      isValidLoginPass.value = false;
      res = "Please enter password";
    }
    update();
    return res;
  }

  /**********************************
   * On SignIn
   */
  onSignIn() async {
    EasyLoading.show();
    try {
      String phone = phoneNumber.value;
      String password = loginPasswordController.text;
      final data = {
        'phone': phone,
        'password': password,
      };

      final res = await UserRepository.login(data);
      Logger().i(res);
      if (res['statusCode'] == 200) {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: "OTP code sent to your phone number.");

        isSignInFlow = true;

        //  GO TO OPT VERIFY PAGE
        Get.toNamed(Routes.VERIFY_PAGE);
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
    // Get.toNamed(Routes.VERIFY_PAGE);
  }

  // /**********************
  //  * OnChaning Login Pass
  //  */
  // void onChangeLoginPass(String? value) {
  //   validateLoginPass(value);
  //   update();
  // }

  ///////////////////////////////////// SIGN UP /////////////////////////////////////////////
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final signUpUsernameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpConfirmpassController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  final isValidSignupUsername = false.obs;
  final signUpphoneNumber = "".obs;
  final isValidSignupPhone = false.obs;

  final isValidSignupOldPass = false.obs;
  final isValidSignupNewPass = false.obs;
  final isAccept = false.obs;

  /**********************
   * Update Accept Check
   */
  updateAcceptCheck(bool? value) {
    if (value != null) {
      isAccept.value = value;
      update();
    }
  }

  /*********************
   * Validate Username
   */
  String? validateSignupUsername(String? value) {
    String? res = null;
    if (value != null) {
      if (value.length > 30) {
        res = 'Username should be less than 30 characters';
        isValidSignupUsername.value = false;
      } else if (value.length < 3) {
        res = 'Username should be longer than 3 characters';
        isValidSignupUsername.value = false;
      } else if (value.isEmpty) {
        isValidSignupUsername.value = false;

        res = 'Username is required!';
      } else {
        isValidSignupUsername.value = true;
      }
    } else {
      isValidSignupUsername.value = false;
    }
    update();
    return res;
  }

  /************************
   * Validate Old Password 
   */
  String? validateSignupOldPass(String? value) {
    String? res = null;
    isValidSignupOldPass.value = false;
    if (value != null) {
      if (value.length < 8) {
        isValidSignupOldPass.value = false;
        res = 'Password should be at least 8 characters';
      } else if (value.length > 30) {
        isValidSignupOldPass.value = false;
        res = 'Password should be less than 30 characters';
      } else if (value.isEmpty) {
        isValidSignupOldPass.value = false;
        res = 'Password is required.';
      } else {
        isValidSignupOldPass.value = true;
        res = null;
      }
    } else {
      isValidSignupOldPass.value = false;
      res = "Please enter password";
    }
    update();
    return res;
  }

  /************************
   * Validate New Password 
   */
  String? validateSignupNewPass(String? value) {
    String? res = null;
    isValidSignupNewPass.value = false;
    if (value != null) {
      if (value.length < 8) {
        isValidSignupNewPass.value = false;
        res = 'Password should be at least 8 characters';
      } else if (value.length > 30) {
        isValidSignupNewPass.value = false;
        res = 'Password should be less than 30 characters';
      } else if (value.isEmpty) {
        isValidSignupNewPass.value = false;
        res = 'Password is required.';
      } else if (value != signUpPasswordController.text) {
        isValidSignupNewPass.value = false;
        res = 'Password is not match';
      } else {
        isValidSignupNewPass.value = true;
        res = null;
      }
    } else {
      isValidSignupNewPass.value = false;
      res = "Please enter password";
    }
    update();
    return res;
  }

  /******************************
   * Validate SignUp Phone Number
   */
  String? validateSignUpPhone(PhoneNumber? number) {
    try {
      if (number != null) {
        isValidSignupPhone.value = number.isValidNumber();
      } else {
        isValidSignupPhone.value = false;
      }
    } catch (e) {
      isValidSignupPhone.value = false;
    }

    update();
    return isValidSignupPhone.value ? null : "Invalid Mobile Number";
  }

  /*********************
   * Update SingUp Phone
   */
  void updateSignUpPhoneNumber(PhoneNumber? number) {
    signUpphoneNumber.value = number?.completeNumber ?? "";
    validateSignUpPhone(number);
    update();
  }

  /*******************************************
   * On SignUp
   */
  onSignUp() async {
    EasyLoading.show();

    try {
      if (signUpFormKey.currentState!.validate()) {
        if (!isAccept.value) {
          // IF NOT ACCEPT TEMRS
          CustomSnackBar.showCustomErrorSnackBar(
              title: "WARNING", message: "Please accept Temrs and conditions!");
          EasyLoading.dismiss();

          return;
        }
        String username = signUpUsernameController.text;
        String phone = signUpphoneNumber.value;
        String password = signUpPasswordController.text;
        final data = {
          'username': username,
          'phone': phone,
          "password": password
        };
        final res = await UserRepository.register(data);
        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS",
              message:
                  "SignUp successfully! OPT code sent to your phone number.");

          isSignInFlow = false;
          //  GO TO OPT VERIFY PAGE
          Get.toNamed(Routes.VERIFY_PAGE);
        } else {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomErrorSnackBar(
              title: "ERROR",
              message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  ////////////////////////// VERIFY OTP CODE /////////////////////
  final verifyCode = "".obs;
  /**************************
   * Set Verification  Code
   */
  setVerifyCode(String code) {
    verifyCode.value = code;
    update();
  }

  /***************************
   * Resend OTP Code
   */
  resendOtpCode() async {
    try {
      EasyLoading.show();
      String phone =
          isSignInFlow ? "${phoneNumber.value}" : "${signUpphoneNumber.value}";
      final res = await UserRepository.resendOtpCode({'phone': phone});
      Logger().i(res);
      if (res['statusCode'] == 200) {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: res['message']);
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  /************************************
   * On Confirm verify
   */
  onConfirmVerifyCode() async {
    try {
      EasyLoading.show();
      String code = verifyCode.value;
      String phone =
          isSignInFlow ? "${phoneNumber.value}" : "${signUpphoneNumber.value}";
      final res =
          await UserRepository.verifyCode({'otp': code, 'phone': phone});
      Logger().i(res);
      if (res['statusCode'] == 200) {
        final userData = res['data']['user'];
        print(userData['id']);
        _userModel.value = UserModel.fromJson(userData);

        initSignUpDetail(authUser!);

        // SAVE USER DATA IN LOCAL
        await saveUserData(res['data']['token'], userData);

        EasyLoading.dismiss();

        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: res['message']);

        Get.offAllNamed(Routes.SIGNUP_DETAIL);
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  saveUserData(token, data) async {
    print(token);
    print(data['id']);
    print(data['username']);
    // TOKEN
    await storeDataToLocal(
        key: AppLocalKeys.TOKEN, value: token, type: StorableDataType.String);

    // USER ID
    await storeDataToLocal(
        key: AppLocalKeys.USERID,
        value: data['id'],
        type: StorableDataType.INT);

    // USER NAME
    await storeDataToLocal(
        key: AppLocalKeys.USERNAME,
        value: data['username'],
        type: StorableDataType.String);
  }

  ///////////////////////// SIGN UP DETAIL  /////////////////////
  final GlobalKey<FormState> detailFormKey = GlobalKey<FormState>();
  final detailFirstNameController = TextEditingController();
  final detailLastNameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final birthController = TextEditingController();
  final detailEmailController = TextEditingController();
  final licenseStateController = TextEditingController();
  final licenseNumberController = TextEditingController();

  final isValidDetailFName = false.obs;
  final isValidDetailLName = false.obs;

  final isValidDetailStreet = false.obs;
  final isValidDetailCity = false.obs;
  final isValidDetailState = false.obs;
  final isValidDetailZip = false.obs;
  final isValidDetailBirth = false.obs;
  final isValidDetailEmail = false.obs;
  final isValidDetailLState = false.obs;
  final isValidDetailLNumber = false.obs;
  DateTime selectedDate = DateTime.now();

  final _detailState = "Alabama".obs;
  String get detailState => _detailState.value;

  final _detailLicenseState = "Alabama".obs;
  String get detailLicenseState => _detailLicenseState.value;

  final fID = Rxn<String>();
  final bID = Rxn<String>();
  final selfie = Rxn<String>();

  initSignUpDetail(UserModel user) {
    if (user.firstName != null) {
      detailFirstNameController.text = user.firstName!;
    }
    if (user.lastName != null) {
      detailLastNameController.text = user.lastName!;
    }
    if (user.street != null) {
      streetController.text = user.street!;
    }
    if (user.city != null) {
      cityController.text = user.city!;
    }
    if (user.zipcode != null) {
      zipController.text = user.zipcode!.toString();
    }

    // if (user.birthday != null) {
    //   zipController.text = user.birthday!.toString();
    // }

    if (user.email != null) {
      detailEmailController.text = user.email!.toString();
    }

    if (user.licenseState != null) {
      licenseStateController.text = user.licenseState!.toString();
    }

    if (user.licenseNumber != null) {
      licenseNumberController.text = user.licenseNumber!.toString();
    }
  }

  /****************************
   * update State
   */
  updateDetailState(String state) {
    _detailState.value = state;
    update();
  }

  /****************************
   * update State
   */
  updateDetailLicenseState(String state) {
    _detailLicenseState.value = state;
    update();
  }

  /****************************
   * Validate Detail First Name
   */
  String? validateFName(String? value) {
    String? res = null;
    isValidDetailFName.value = false;
    if (value != null) {
      if (value.length > 30) {
        isValidDetailFName.value = false;
        res = 'First Name should be less than 30 characters';
      } else if (value.isEmpty) {
        isValidDetailFName.value = false;
        res = 'First Name is required.';
      } else {
        isValidDetailFName.value = true;
        res = null;
      }
    } else {
      isValidDetailFName.value = false;
      res = "Please enter First Name";
    }
    update();
    return res;
  }

  /****************************
   * Validate Detail Last Name
   */
  String? validateLName(String? value) {
    String? res = null;
    isValidDetailLName.value = false;
    if (value != null) {
      if (value.length > 30) {
        isValidDetailLName.value = false;
        res = 'Last Name should be less than 30 characters';
      } else if (value.isEmpty) {
        isValidDetailLName.value = false;
        res = 'Last Name is required.';
      } else {
        isValidDetailLName.value = true;
        res = null;
      }
    } else {
      isValidDetailLName.value = false;
      res = "Please enter Last Name";
    }
    update();
    return res;
  }

  /****************************
   * Validate Detail Street
   */
  String? validateStreet(String? value) {
    String? res = null;
    isValidDetailStreet.value = false;
    if (value != null) {
      if (value.length > 100) {
        isValidDetailStreet.value = false;
        res = 'Street should be less than 100 characters';
      } else if (value.isEmpty) {
        isValidDetailStreet.value = false;
        res = 'Street is required.';
      } else {
        isValidDetailStreet.value = true;
        res = null;
      }
    } else {
      isValidDetailStreet.value = false;
      res = "Please enter Street";
    }
    update();
    return res;
  }

  /************************
   * Validate City 
   */
  String? validateDetailCity(String? value) {
    String? res = null;
    isValidDetailCity.value = false;
    if (value != null) {
      if (value.length > 100) {
        isValidDetailCity.value = false;
        res = 'Street should be less than 100 characters';
      } else if (value.isEmpty) {
        isValidDetailCity.value = false;
        res = 'Street is required.';
      } else {
        isValidDetailCity.value = true;
        res = null;
      }
    } else {
      isValidDetailCity.value = false;
      res = "Please enter Street";
    }
    update();
    return res;
  }

  /************************
   * Validate Zip 
   */
  String? validateDetailZip(String? value) {
    String? res = null;
    isValidDetailCity.value = false;
    if (value != null) {
      if (!Regex.validateZipCode(value)) {
        isValidDetailCity.value = false;
        res = 'Invalid Zipcode!';
      } else {
        isValidDetailCity.value = true;
        res = null;
      }
    } else {
      isValidDetailCity.value = false;
      res = "Please enter zipcode";
    }
    update();
    return res;
  }

  String? validateBirthDay(String? value) {
    Logger().i(value);
    String? res = null;
    isValidDetailBirth.value = false;
    if (value != null) {
      if (!Regex.validateDate(value)) {
        isValidDetailBirth.value = false;
        res = 'Invalid Birthday!';
      } else {
        isValidDetailBirth.value = true;
        res = null;
      }
    } else {
      isValidDetailBirth.value = false;
      res = "Please enter birthday";
    }
    update();
    return res;
  }

  /************************
   * Select BirthDay
   */
  selectBirthday() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      birthController.text = formattedDate;
      // isValidDetailBirth.value = true;
      // update();
      validateBirthDay(formattedDate);
      update();
    }
  }

  /****************************
   * Validate Detail Email
   */
  String? validateDetailEmail(String? value) {
    if (!Regex.isEmail(value!)) {
      return 'Email format invalid.';
    }

    if (value.isEmpty) {
      return 'Email is required.';
    }
    return null;
  }

  /********************************
   * Validate Detail License Number
   */
  String? validateDetailLNumber(String? value) {
    if (!Regex.isEmail(value!)) {
      return 'Email format invalid.';
    }

    if (value.isEmpty) {
      return 'Email is required.';
    }
    return null;
  }

  // /************************
  //  * Validate City
  //  */
  // String? validateDetailCity(String? value) {
  //   String? res = null;
  //   isValidDetailCity.value = false;
  //   if (value != null) {
  //     if (value.length > 100) {
  //       isValidDetailCity.value = false;
  //       res = 'Street should be less than 100 characters';
  //     } else if (value.isEmpty) {
  //       isValidDetailCity.value = false;
  //       res = 'Street is required.';
  //     } else {
  //       isValidDetailCity.value = true;
  //       res = null;
  //     }
  //   } else {
  //     isValidDetailCity.value = false;
  //     res = "Please enter Street";
  //   }
  //   update();
  //   return res;
  // }

  // /************************
  //  * Validate State
  //  */
  // String? validateDetailState(String? value) {
  //   String? res = null;
  //   isValidSignupNewPass.value = false;
  //   if (value != null) {
  //     if (value.length < 8) {
  //       isValidSignupNewPass.value = false;
  //       res = 'State should be at least 8 characters';
  //     } else if (value.length > 30) {
  //       isValidSignupNewPass.value = false;
  //       res = 'State should be less than 30 characters';
  //     } else if (value.isEmpty) {
  //       isValidSignupNewPass.value = false;
  //       res = 'State is required.';
  //     } else {
  //       isValidSignupNewPass.value = true;
  //       res = null;
  //     }
  //   } else {
  //     isValidSignupNewPass.value = false;
  //     res = "Please enter State";
  //   }
  //   update();
  //   return res;
  // }

  /******************************
   * On Submit Detail of User
   */

  onSubmitDetail() async {
    if (fID.value == null || bID.value == null || selfie.value == null) {
      CustomSnackBar.showCustomErrorSnackBar(
          title: "WARNING", message: Messages.WARNING_UPLOAD_DOCUMENT);
      return;
    }
    if (detailFormKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        final data = {
          'uid': _userModel.value?.id ?? 0,
          'first_name': detailFirstNameController.text,
          'last_name': detailLastNameController.text,
          'street': streetController.text,
          'city': cityController.text,
          'state': detailState,
          'zipcode': zipController.text,
          'birthday': birthController.text,
          'email': detailEmailController.text,
          'licenseState': detailLicenseState,
          'licenseNumber': licenseNumberController.text,
          'frontID': fID.value,
          'backID': bID.value,
          'selfie': selfie.value,
        };

        Logger().i(data);

        final res = await UserRepository.saveUserDetail(data);
        Logger().i(res);
        if (res['statusCode'] == 200) {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS", message: "OTP code sent to your phone number.");

          isSignInFlow = true;

          //  GO TO OPT VERIFY PAGE
          // Get.toNamed(Routes.VERIFY_PAGE);
        } else {
          EasyLoading.dismiss();

          CustomSnackBar.showCustomErrorSnackBar(
              title: "ERROR",
              message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        }
      } catch (e) {
        EasyLoading.dismiss();

        Logger().e(e.toString());
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
      }
    }
  }

  final auth = FirebaseAuth.instance;

  // final nextPage = ProjectsPageView();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToNextPage() async {
    Logger().i("Initialization");
    PermissionStatus cameraStatus = await checkCameraPermission();
    PermissionStatus galleryStatus = await checkGalleryPermission();

    // if (!cameraStatus.isGranted &&  !galleryStatus.isGranted) {

    //  Logger().e("All not granted");
    //   Get.offAll(()=> WelcomeView(index : 0 ));

    // } else if (!cameraStatus.isGranted ) {
    //  Logger().e("Camera not granted");

    //   Get.offAll(()=> WelcomeView(index : 1 ));

    // } else if (!galleryStatus.isGranted) {
    //  Logger().e("gallery not granted");

    //   Get.offAll(()=> WelcomeView(index :2 ));

    // } else {
    //        Logger().i("All are granted");
    // Get.offAll(()=>ProjectsPageView());
    // }
  }

  /////////////////////////////////////////// SIGN IN ////////////////////////////////////////////
  /******************************
   * Login With Email & Password
   */
  void signInWithEmail() async {
    String email = loginPhoneController.text.trim();
    String password = loginPasswordController.text.trim();
    if (loginFormKey.currentState!.validate()) {
      EasyLoading.show(status: "Loading...");
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        EasyLoading.dismiss();
        if (auth.currentUser != null) {
          // Save Login Method as Email
          saveLoginMethod(LoginMethod.EMAIL);

          goToNextPage();
        } else {
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Failed!', message: "Opps! Please try again.");
        }
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: "Invalid username or password");
      }
    }
  }

  /**************************
   * Pick Photo
   */
  Future<void> pickPhoto(ImageSource source, DOCUMENT_ID type) async {
    if (source == ImageSource.camera) {
      await requestCameraPermission();
    } else if (source == ImageSource.gallery) {
      await requestGalleryPermission();
    }
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      File pickedFile = File(pickedImage.path);
      String? filePath = await uploadFile(pickedFile);
      if (filePath != null) {}
      switch (type) {
        case DOCUMENT_ID.FRONT_ID:
          fID.value = filePath;

          break;
        case DOCUMENT_ID.BACK_ID:
          bID.value = filePath;

          break;
        case DOCUMENT_ID.SELFIE:
          selfie.value = filePath;
          break;
        default:
      }
      update();
    }
  }

  /*******************
   * Upload File
   */
  Future<String?> uploadFile(File file) async {
    EasyLoading.show();
    try {
      final res = await UserRepository.uploadFile(file);
      Logger().i(res);
      if (res.statusCode == 200) {
        final responseData = await res.stream.bytesToString();

        final data = jsonDecode(responseData);
        Logger().i(data);

        EasyLoading.dismiss();

        return data['data']['filePath'];
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
      return null;
    }
  }

  /********************************
   * Show BottomSheet Choose Photo
   */
  showBottomSheetIDPhoto(BuildContext context, DOCUMENT_ID type) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickPhoto(ImageSource.camera, type);
                },
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text("Take a photo")),
            ListTile(
                onTap: () async {
                  Get.back();
                  await pickPhoto(ImageSource.gallery, type);
                },
                leading: Icon(
                  Icons.folder_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text("Choose from Gallery")),
          ],
        );
      },
    );
  }

  /******************
   * Check User Exist
   */
  // Future<Map<String, dynamic>> checkUser(
  //   User user, {
  //   bool isGoogle = true,
  // }) async {
  //   // FirebaseChatCore.instance
  //   //     .createGroupRoom(name: DatabaseConfig.FEED_ROOM_NAME, users: [
  //   //   types.User(id: FirebaseAuth.instance.currentUser!.uid),
  //   // ]);
  //   Map<String, dynamic> _returnData = {
  //     "isExist": false,
  //     "isBlocked": false,
  //   };

  //   final userRef =
  //       FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);
  //   return await userRef.doc(user.uid).get().then(
  //     (doc) async {
  //       if (doc.exists) {
  //         // Get.offAll(() => const WelcomPage());
  //         final data = doc.data();

  //         bool _isBlocked = data!['metadata']['blocked'] != null
  //             ? data['metadata']['blocked']
  //             : false;

  //         _returnData['isBlocked'] = _isBlocked;
  //         _returnData['isExist'] = true;

  //         if (_isBlocked) {
  //           return _returnData;
  //         }
  //         data['id'] = user.uid;
  //         if (data['metadata'] != null) {
  //           data['metadata']['status'] = "online";
  //         } else {
  //           data['metadata'] = {'status': "online"};
  //         }
  //         types.User _user = types.User.fromJson(data);
  //         authUser.value = _user;
  //         try {
  //           await updateUser(user: _user);
  //           await MySharedPref.saveData(
  //               value: true, key: MySharedPref.IS_LOGIN, type: PrefType.BOOL);
  //           await MySharedPref.saveData(
  //               value: "${_user.firstName} ${_user.lastName}",
  //               key: MySharedPref.LOGIN_NAME,
  //               type: PrefType.STRING);
  //           await MySharedPref.saveData(
  //               value: auth.currentUser!.email,
  //               key: MySharedPref.LOGIN_EMAIL,
  //               type: PrefType.STRING);
  //           return _returnData;
  //         } catch (e) {
  //           throw e;
  //         }
  //       } else {
  //         // await signOut(isGoogle: isGoogle);
  //         return _returnData;
  //       }
  //     },
  //   );
  // }

  /**************************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.2.20
   * @Desc: SignUp with Email Password
   */
  void signUpWithEmail() async {
    if (signUpFormKey.currentState!.validate()) {
      EasyLoading.show(status: 'loading...');

      // SignUp With Email & Password
      String email = signUpEmailController.text.trim();
      String username = signUpUsernameController.text.trim();
      String password = signUpPasswordController.text.trim();
      try {
        final user = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (user.user != null) {
          try {
            // await saveUser(email: email, name: username);

            EasyLoading.dismiss();

            // Save User Login Method
            saveLoginMethod(LoginMethod.EMAIL);

            goToNextPage();
          } catch (e) {
            Logger().e(e);
            EasyLoading.dismiss();
            CustomSnackBar.showCustomErrorSnackBar(
                title: 'Failed!', message: "Something went wrong");
          }

          // saveUser(name: name);
        }
        // EasyLoading.dismiss();
      } on FirebaseAuthException catch (e) {
        // Get.back();
        Logger().e(e.message);

        EasyLoading.dismiss();
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: "${e.message.toString()}");
        // CustomSnackBar.showCustomSnackBar(title: 'Done successfully!', message: 'item added to wishlist');
      }
    }
  }

  /**********************************
   * @Auth: geniusdev0813@gmail.com
   * @Date: 2023.2.20
   * @Desc: Google Login
   */
  void googleAuthentication({required bool isLogin}) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final googleSignin = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final user = await auth.signInWithCredential(credential);
        if (user.user != null) {
          await saveLoginMethod(LoginMethod.GOOGLE);
          EasyLoading.dismiss();

          goToNextPage();

          // if (isLogin) {
          //   // Save Login Method as Google
          //   goToNextPage();
          // } else {
          //   Logger().d("Google SignUp");
          //   await saveUser(
          //     name: googleUser.displayName!,
          //     email: googleUser.email,
          //     imgUrl: googleUser.photoUrl,
          //   );
          // }
        } else {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Failed!', message: "Something went wrong, Please retry!");
        }
      } else {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: "Something went wrong, Please retry!");
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!', message: "Something went wrong, Please retry!");
    } catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!', message: "Somthing went wrong, Please retry!");
    }
  }

  void appleAuthentication({required bool isLogin}) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final appleResult = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      if (appleResult != null) {
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: appleResult.identityToken,
          accessToken: appleResult.authorizationCode,
        );
        final user = await auth.signInWithCredential(credential);
        if (user.user != null) {
          // if (isLogin) {

          // } else {
          //   await saveUser(
          //     name:
          //         '${appleResult.givenName ?? ''} ${appleResult.familyName ?? ''}',
          //     email: appleResult.email ?? '',
          //   );
          // }

          // Save Login Method as Apple
          await saveLoginMethod(LoginMethod.APPLE);
          EasyLoading.dismiss();

          goToNextPage();
        } else {
          EasyLoading.dismiss();
          CustomSnackBar.showCustomErrorSnackBar(
              title: 'Failed!', message: "Something went wrong. Please retry!");
        }
      } else {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: "Something went wrong. Please retry!");
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!',
          message: "Oops! Something went wrong. Please retry!");
    } catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!',
          message: "Oops! Something went wrong. Please retry!");
    }
  }

  // saveUser({
  //   required String name,
  //   required String email,
  //   String? imgUrl,
  // }) async {
  //   final splitted = name.split(' ');
  //   String firstName = "";
  //   String lastName = "";
  //   if (splitted.length > 1) {
  //     firstName = splitted[0];
  //     lastName = splitted[1];
  //   } else {
  //     firstName = splitted[0];
  //   }
  //   // if (!await MobileNumber.hasPhonePermission) {
  //   //   await MobileNumber.requestPhonePermission;
  //   // }
  //   // List<SimCard>? mobileNumber = await MobileNumber.getSimCards;

  //   Map<String, dynamic> saveData = {
  //     'email': email,
  //     'name': name,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'imageUrl': imgUrl ??
  //         (auth.currentUser != null ? auth.currentUser!.photoURL : ""),
  //     'metadata': {
  //       'status': "online",
  //       'phone': ""
  //       // 'phone': mobileNumber != null && mobileNumber.isNotEmpty
  //       //     ? mobileNumber[0].number
  //       //     : null,
  //     }
  //   };

  //   await FirebaseFirestore.instance
  //       .collection(DatabaseConfig.USER_COLLECTION)
  //       .doc(auth.currentUser!.uid)
  //       .set(saveData);

  //   saveData['id'] = auth.currentUser!.uid;
  //   types.User _user = types.User.fromJson(saveData);
  //   authUser.value = _user;

  //   final feedRef =
  //       FirebaseFirestore.instance.collection(DatabaseConfig.CHAT_COLLECTION);
  //   await feedRef.doc(DatabaseConfig.FEED_ROOM_ID).get().then(
  //     (doc) async {
  //       if (doc.exists) {
  //         Map<String, dynamic>? data = doc.data();
  //         List users = data!['userIds'];
  //         if (!users.contains(auth.currentUser!.uid)) {
  //           users.add(auth.currentUser!.uid);
  //           data['userIds'] = users;

  //           await FirebaseFirestore.instance
  //               .collection(DatabaseConfi g.CHAT_COLLECTION)
  //               .doc(DatabaseConfig.FEED_ROOM_ID)
  //               .update(data);
  //         }

  //         await MySharedPref.saveData(
  //             value: true, key: MySharedPref.IS_LOGIN, type: PrefType.BOOL);

  //         await MySharedPref.saveData(
  //             value: name, key: MySharedPref.LOGIN_NAME, type: PrefType.STRING);
  //         await MySharedPref.saveData(
  //             value: auth.currentUser!.email,
  //             key: MySharedPref.LOGIN_EMAIL,
  //             type: PrefType.STRING);
  //         // List<types.User> users =
  //         // _feedRoom.users.add(types.User(id: auth.currentUser!.uid));
  //         // users.add(types.User(id: auth.currentUser!.uid));
  //         // _feedRoom.users = users;
  //         // types.Room updateRoom = _feedRoom.copyWith(users: users);

  //         // FirebaseChatCore.instance.updateRoom(_feedRoom);

  //         // if (!isAgreeTerms) {
  //         Get.offAll(() => TermsView(isFirst: true));
  //         // } else {
  //         //   goToNextPage();
  //         // }
  //       }
  //     },
  //   );
  // }

  // updateUser({required types.User user}) async {
  //   await FirebaseFirestore.instance
  //       .collection(DatabaseConfig.USER_COLLECTION)
  //       .doc(auth.currentUser!.uid)
  //       .update(user.toJson());
  // }

  signOut() async {
    LoginMethod method = await getLoginMethod();
    switch (method) {
      case LoginMethod.EMAIL:
        await FirebaseAuth.instance.signOut();
        break;
      case LoginMethod.GOOGLE:
        await GoogleSignIn().signOut();
      default:
        await FirebaseAuth.instance.signOut();
        break;
    }

    Get.offAll(SignInView());
  }

  /*********************************
   * @author: geniusdev0813@gmail.com
   * @date:   2023.6.18
   * @desc:   Save Login Method
   */
  Future<void> saveLoginMethod(LoginMethod method) async {
    int _methodNum = 0;
    switch (method) {
      case LoginMethod.EMAIL:
        _methodNum = 1;
        break;

      case LoginMethod.GOOGLE:
        _methodNum = 2;
        break;
      case LoginMethod.APPLE:
        _methodNum = 3;
        break;
      default:
    }

    await MySharedPref.saveData(
        value: _methodNum, key: MySharedPref.LOGIN_METHOD, type: PrefType.INT);
  }

  /****************************************************
   * @author: geniusdev0813@gmail.com
   * @date: 2023.6.18
   * @desc: Get Login Method
   */
  Future<LoginMethod> getLoginMethod() async {
    int _methodNum = await MySharedPref.getData(
            key: MySharedPref.LOGIN_METHOD, type: PrefType.INT) ??
        1;
    switch (_methodNum) {
      case 1:
        return LoginMethod.EMAIL;
      case 2:
        return LoginMethod.GOOGLE;
      case 3:
        return LoginMethod.APPLE;
      default:
        return LoginMethod.OTHER;
    }
  }

  // //////////////////////////////////////// Update Email //////////////////////////
  // final GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();
  // final UEFEmailController = TextEditingController();
  // final UEFConfirmEmailController = TextEditingController();
  // final UEFPasswordController = TextEditingController();
  // /*************************************
  //  * @Auth: geniusdev0813@gmail.com
  //  * @Date: 2023.3.10
  //  * @Desc: Update Email in Setting Page
  //  */
  // updateEmail() async {
  //   if (updateEmailFormKey.currentState!.validate()) {
  //     String password = UEFPasswordController.text;
  //     String email = UEFEmailController.text;
  //     try {
  //       EasyLoading.show(status: "Updating...");

  //       auth.currentUser!
  //           .reauthenticateWithCredential(EmailAuthProvider.credential(
  //               email: auth.currentUser!.email!, password: password))
  //           .then((value) async {
  //         if (value != null) {
  //           // Update FirebaseAuth Email
  //           await FirebaseAuth.instance.currentUser!.updateEmail(email);

  //           // Update Database Email
  //           await FirebaseFirestore.instance
  //               .collection(DatabaseConfig.USER_COLLECTION)
  //               .doc(auth.currentUser!.uid)
  //               .update({"email": email});

  //           await MySharedPref.saveData(
  //               value: email,
  //               key: MySharedPref.LOGIN_EMAIL,
  //               type: PrefType.STRING);
  //           Map<String, dynamic> userData = authUser.value!.toJson();
  //           userData['email'] = email;
  //           authUser.value = types.User.fromJson(userData);
  //           // Clear Text Contoller
  //           UEFConfirmEmailController.text = "";
  //           UEFPasswordController.text = "";
  //           UEFEmailController.text = "";
  //           update();

  //           EasyLoading.dismiss();
  //           CustomSnackBar.showCustomSnackBar(
  //               title: 'SUCCESS', message: "Email is updated successfully!");
  //         } else {
  //           EasyLoading.dismiss();

  //           CustomSnackBar.showCustomErrorSnackBar(
  //               title: 'Failed!',
  //               message: "Oops! Something went wrong. \r\nPlease retry!");
  //         }
  //       }).catchError((onError) {
  //         Logger().e(onError.toString());
  //         EasyLoading.dismiss();

  //         CustomSnackBar.showCustomErrorSnackBar(
  //             title: 'Failed!',
  //             message: "Oops! Something went wrong. \r\nPlease retry!");
  //       });
  //     } catch (e) {
  //       Logger().e("Som");
  //       EasyLoading.dismiss();

  //       CustomSnackBar.showCustomErrorSnackBar(
  //           title: 'Failed!',
  //           message: "Oops! Something went wrong. \r\nPlease retry!");
  //     }
  //   } else {
  //     Logger().e("Validate Error");
  //   }
  // }

  // /************************************
  //  * @Date: 2023.3.10
  //  * @Desc: Save Login Log
  //  */
  // saveLoginLog() async {
  //   final _locationServiceController = Get.find<LocationServiceController>();

  //   final location = _locationServiceController.myLocation;
  //   String address = "";
  //   String deviceID = "";
  //   String deviceModel = "";
  //   String type = "android";
  //   String locationString = "";
  //   try {
  //     try {
  //       List<Placemark> placemarks = await placemarkFromCoordinates(
  //           location!.latitude, location.longitude);
  //       locationString = "${location.latitude}, ${location.longitude}";
  //       if (placemarks.isNotEmpty) {
  //         Placemark addressMark = placemarks[0];
  //         String countryCode = addressMark.isoCountryCode ?? "";
  //         String city = addressMark.locality ?? "";
  //         address = "$city, $countryCode";
  //       }
  //     } catch (e) {
  //       Logger().e("Location Error", "Som");
  //     }

  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       deviceID = androidInfo.display;
  //       String model = androidInfo.model;
  //       String version = androidInfo.version.release;
  //       deviceModel = "$model $version";
  //       type = "android";
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       deviceID = iosInfo.identifierForVendor ?? "Unknown";
  //       String model = iosInfo.model ?? "Unknown";
  //       String version = iosInfo.systemVersion ?? "1";
  //       deviceModel = "$model $version";
  //       type = "iPhone";
  //     }

  //     LoginLogModel _loginModel = LoginLogModel(
  //         deviceID: deviceID,
  //         deviceModel: deviceModel,
  //         deviceType: type,
  //         location: locationString,
  //         address: address);
  //     // Save data into firebase
  //     await FirebaseFirestore.instance
  //         .collection(DatabaseConfig.LOGIN_LOG_COLLECTION)
  //         .doc()
  //         .set(_loginModel.toJson());
  //   } catch (e) {
  //     Logger().e("Som");
  //   }
  // }

  // //////////////////////////////////////// Update Password //////////////////////////
  // final GlobalKey<FormState> updatePasswordFormKey = GlobalKey<FormState>();
  // final UPFcurrentPassController = TextEditingController();
  // final UPFConfirmPasswordController = TextEditingController();
  // final UPFnewPassController = TextEditingController();
  // final isSamePass = false.obs;
  // /*************************************
  //  * @Auth: geniusdev0813@gmail.com
  //  * @Date: 2023.3.10
  //  * @Desc: Update Password in Setting Page
  //  */
  // updatePassword() async {
  //   if (updatePasswordFormKey.currentState!.validate()) {
  //     String password = UPFnewPassController.text;
  //     String oldPassword = UPFcurrentPassController.text;
  //     if (oldPassword == password) {
  //       isSamePass.value = true;
  //       update();
  //       return;
  //     }
  //     try {
  //       EasyLoading.show(status: "Updating...");
  //       auth
  //           .signInWithEmailAndPassword(
  //               email: auth.currentUser!.email!, password: oldPassword)
  //           .then((value) async {
  //         if (oldPassword == password) {
  //           isSamePass.value = true;
  //           update();
  //           EasyLoading.dismiss();
  //           return;
  //         } else {
  //           isSamePass.value = false;
  //           update();
  //           await auth.currentUser!.updatePassword(password);

  //           // Clear Text Controller
  //           UPFnewPassController.text = "";
  //           UPFcurrentPassController.text = "";
  //           UPFConfirmPasswordController.text = "";

  //           EasyLoading.dismiss();
  //           CustomSnackBar.showCustomSnackBar(
  //               title: 'SUCCESS', message: "Password is updated successfully!");
  //         }
  //       }).catchError((onError) {
  //         EasyLoading.dismiss();
  //         isSamePass.value = false;
  //         update();
  //         CustomSnackBar.showCustomErrorSnackBar(
  //             title: 'Failed!',
  //             message:
  //                 "Oops! Current password is incorrect. \r\nPlease retry!");
  //       });
  //     } catch (e) {
  //       Logger().e("Som");
  //       EasyLoading.dismiss();
  //       isSamePass.value = false;
  //       update();
  //       CustomSnackBar.showCustomErrorSnackBar(
  //           title: 'Failed!', message: "Som");
  //     }
  //   } else {
  //     isSamePass.value = false;
  //     update();
  //     Logger().e("Validate Error");
  //   }
  // }

  // /*******************************
  //  * @Desc: Delete Account
  //  */
  // Future<bool> deleteAccount(String password) async {
  //   try {
  //     EasyLoading.show();
  //     if (auth.currentUser != null) {
  //       AuthCredential credentials = EmailAuthProvider.credential(
  //           email: auth.currentUser!.email!, password: password);

  //       return await auth.currentUser!
  //           .reauthenticateWithCredential(credentials)
  //           .then((result) async {
  //         // Delete Database User
  //         await FirebaseFirestore.instance
  //             .collection(DatabaseConfig.USER_COLLECTION)
  //             .doc(auth.currentUser!.uid)
  //             .delete();

  //         // Delete FirebaseAuth Account
  //         await result.user!.delete();

  //         EasyLoading.dismiss();
  //         CustomSnackBar.showCustomSnackBar(
  //             title: 'Success',
  //             message: "Your account is deleted successfully!");
  //         return true;
  //       }).onError((FirebaseAuthException error, stackTrace) {
  //         Logger().e(error.toString());
  //         EasyLoading.dismiss();
  //         CustomSnackBar.showCustomErrorSnackBar(
  //             title: 'Failed!', message: "Something went wrong!");
  //         return false;
  //       });
  //     } else {
  //       EasyLoading.dismiss();
  //       CustomSnackBar.showCustomErrorSnackBar(
  //           title: 'Failed!',
  //           message: "Oops! Something went wrong. \r\nPlease retry!");
  //       return false;
  //     }
  //   } catch (e) {
  //     Logger().e("Som");

  //     EasyLoading.dismiss();
  //     CustomSnackBar.showCustomErrorSnackBar(title: 'Failed!', message: "Som");
  //     return false;
  //   }
  // }
}

enum DOCUMENT_ID {
  FRONT_ID,
  BACK_ID,
  SELFIE,
}
