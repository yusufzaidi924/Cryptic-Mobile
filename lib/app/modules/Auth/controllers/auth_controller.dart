// import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/awesome_notifications_helper.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/local_storage.dart';
import 'package:edmonscan/utils/permissionUtil.dart';
import 'package:edmonscan/utils/regex.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/local/my_shared_pref.dart';

// import 'package:edmonscan/app/modules/Home/views/home_view.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

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

  // Firestore user for chat
  final _chatUser = Rxn<User>();
  User? get chatUser => _chatUser.value;

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
    // Get.toNamed(Routes.CHAT_LIST);

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

        // SAVE/GET FIRESTORE USER FOR CHAT
        _chatUser.value = await getFirebaseUser(authUser!);

        initSignUpDetail(authUser!);

        // SAVE USER DATA IN LOCAL
        await saveUserData(res['data']['token'], userData);

        // INIT NOTIFICATION
        await initNotification();

        EasyLoading.dismiss();

        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: res['message']);

        switch (authUser!.status) {
          case 0: // Not Submitted
            Get.toNamed(Routes.SIGNUP_DETAIL);

            break;
          case 1: //  Submitted
            Get.toNamed(Routes.VERIFY_RESULT_PAGE);

            break;

          case 2: //  Approved
            Get.toNamed(Routes.VERIFY_RESULT_PAGE);

            break;

          case -1: //  Rejected
            Get.toNamed(Routes.VERIFY_RESULT_PAGE);

            break;
          default:
        }
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

  /*********************
   * Init After Login
   */
  initNotification() async {
    // inti fcm services
    await FcmHelper.generateFcmToken();
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
    // Logger().i(authUser);
    if (detailFormKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        final data = {
          'uid': authUser?.id ?? 0,
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
          // Update User Model Data
          _userModel.value?.firstName = detailFirstNameController.text;
          _userModel.value?.lastName = detailLastNameController.text;
          _userModel.value?.street = streetController.text;
          _userModel.value?.city = cityController.text;
          _userModel.value?.state = detailState;
          _userModel.value?.zipcode = int.parse(zipController.text);
          _userModel.value?.birthday = DateTime.tryParse(birthController.text);
          _userModel.value?.email = detailEmailController.text;
          _userModel.value?.licenseState = detailLicenseState;
          _userModel.value?.licenseNumber = licenseNumberController.text;
          _userModel.value?.frontID = fID.value;
          _userModel.value?.backID = bID.value;
          _userModel.value?.selfie = selfie.value;

          // Update Firebase User
          _chatUser.value = await updateChatUser(authUser!);

          EasyLoading.dismiss();
          CustomSnackBar.showCustomSnackBar(
              title: "SUCCESS",
              message:
                  "Your information is submitted successfully. Please wait until it is approved!");

          //  GO TO OPT VERIFY PAGE
          _userModel.value!.status = 1;
          Get.toNamed(Routes.VERIFY_RESULT_PAGE);
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

  /**************************
   * Pick Photo
   */
  Future<void> pickPhoto(ImageSource source, DOCUMENT_ID type) async {
    if (source == ImageSource.camera) {
      await requestCameraPermission();
    } else if (source == ImageSource.gallery) {
      await requestGalleryPermission();
    }
    final pickedImage = await ImagePicker().pickImage(source: source);
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
  Future<User> getFirebaseUser(UserModel user) async {
    final userRef =
        FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);
    return await userRef.doc('${user.id}').get().then(
      (doc) async {
        if (doc.exists) {
          final data = doc.data();
          data!['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
          data['id'] = doc.id;
          data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
          data['role'] = 'user';
          data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
          User _user = User.fromJson(data);

          return _user;
        } else {
          User _user = new User(
              id: user.id.toString(),
              imageUrl: user.selfie,
              firstName: user.firstName,
              lastName: user.lastName,
              role: Role.user,
              metadata: {'status': 'online', 'phone': user.phone});

          // await FirebaseFirestore.instance
          //     .collection(DatabaseConfig.USER_COLLECTION)
          //     .doc(user.id.toString())
          //     .set(_user.toJson());
          await FirebaseChatCore.instance.createUserInFirestore(_user);
          return _user;
        }
      },
    );
  }

  /****************************
   * Update User Data 
   */
  Future<User> updateChatUser(UserModel user) async {
    final usersCollection =
        FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);
    final userId = user.id; // Replace with the user ID you want to update

    final userDocRef = usersCollection.doc(userId.toString());
    User newUser = new User(
      id: chatUser!.id,
      firstName: user.firstName,
      lastName: user.lastName,
      imageUrl: user.selfie,
      lastSeen: chatUser!.lastSeen,
      metadata: chatUser!.metadata,
      role: chatUser!.role,
      createdAt: chatUser!.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await userDocRef.update(newUser.toJson());
    return newUser;
  }

  /*******************************
   * @Auth: geniusdev0813@gmail.com
   * @Desc: Restore Account
   * @Date: 2023.10.23
   */
  Future<String> restoreAccount() async {
    String? token = await getDataInLocal(
        key: AppLocalKeys.TOKEN, type: StorableDataType.String);
    if (token == null) {
      return Routes.SIGN_IN;
    } else {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      Logger().d(decodedToken); // print('header: ${jwtData.header}');

      final now = DateTime.now().millisecondsSinceEpoch;
      print(now);
      if (decodedToken['exp'] < now / 1000) {
        Logger().e("👀------- SESSION EXPIRED ---------- 👀");
        return Routes.SIGN_IN;
      } else {
        try {
          final res = await UserRepository.restoreAccount(
              {'uid': decodedToken['userId']});
          Logger().i(res);
          if (res['statusCode'] == 200) {
            final userData = res['data']['user'];
            print(userData['id']);
            _userModel.value = UserModel.fromJson(userData);

            if (authUser!.status == 2) {
              // SAVE/GET FIRESTORE USER FOR CHAT
              _chatUser.value = await getFirebaseUser(authUser!);

              initSignUpDetail(authUser!);

              // SAVE USER DATA IN LOCAL
              await saveUserData(res['data']['token'], userData);

              // INIT NOTIFICATION
              await initNotification();

              // CHECK MNEMONIC CODE
              String? mnemonic_code = await getDataInLocal(
                  key: AppLocalKeys.MNEMONIC_CODE,
                  type: StorableDataType.String);

              Logger().d(mnemonic_code);
              if (mnemonic_code != null) {
                return Routes.HOME;
              } else {
                return Routes.MNEMONIC_PAGE;
              }
            } else {
              return Routes.SIGN_IN;
            }
          } else {
            Logger().e(res['message'] ?? Messages.SOMETHING_WENT_WRONG);
            // CustomSnackBar.showCustomErrorSnackBar(
            //     title: "ERROR",
            //     message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
            return Routes.SIGN_IN;
          }
        } catch (e) {
          Logger().e(e);
          // CustomSnackBar.showCustomErrorSnackBar(
          //     title: "ERROR", message: e.toString());
          return Routes.SIGN_IN;
        }
      }
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
}

enum DOCUMENT_ID {
  FRONT_ID,
  BACK_ID,
  SELFIE,
}
