import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/services/api.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  // ========== LOGIN ==================
  static Future<Map<String, dynamic>> login(data) async {
    var res = await Network().authData(data, Network.LOGIN);
    Logger().i('================= LOGIN WITH CUSTOMER SERVER =============');
    print(res.statusCode);
    Logger().i(res.body);

    var body = json.decode(res.body);
    return body;

    // var result = callback(res);
    // return result;
  }

  static Map<String, dynamic> callback(res) {
    Map<String, dynamic> result;
    switch (res.statusCode) {
      case 200:
        if (res.body != null) {
          Map<String, dynamic> body = json.decode(res.body);
          result = body;
        } else {
          result = {
            'result': false,
            'error': "User doesn't exsit. Please conatct support team"
          };
        }

        break;
      case 204:
        result = {
          'result': false,
          'error': "User doesn't exsit. Please conatct support team"
        };
        break;
      case 400:
        result = {
          'result': false,
          'error': "Something went wrong. Please retry!"
        };
        break;

      case 500:
        result = {'result': false, 'error': "Server error. Please retry!"};
        break;
      default:
        result = {
          'result': false,
          'error': "Something went wrong. Please retry!"
        };
    }
    return result;
  }

  // ========== REGISTER  ==================
  static Future<Map<String, dynamic>> register(data) async {
    var res = await Network().authData(data, Network.REGISTER);
    var body = json.decode(res.body);
    return body;
  }

  // ========== RESEND OPT CODE  ==================
  static Future<Map<String, dynamic>> resendOtpCode(data) async {
    var res = await Network().authData(data, Network.RESEND_OTP_CODE);
    var body = json.decode(res.body);
    return body;
  }

  // ========== VERIFY OPT CODE  ==================
  static Future<Map<String, dynamic>> verifyCode(data) async {
    var res = await Network().authData(data, Network.VERIFY_CODE);
    var body = json.decode(res.body);
    return body;
  }

  // ========== SAVE USER DETAIL  ==================
  static Future<Map<String, dynamic>> saveUserDetail(data) async {
    var res = await Network().authData(data, Network.SAVE_USER_DETAIL);
    var body = json.decode(res.body);
    return body;
  }

  // ========== SEND INVITE SMS TO USER  ==================
  static Future<Map<String, dynamic>> sendInviteSMS(data) async {
    var res = await Network().authData(data, Network.SEND_INVITE_SMS);
    var body = json.decode(res.body);
    return body;
  }

  // ========== UPLOAD FILE  ==================
  static Future uploadFile(File file) async {
    StreamedResponse res =
        await Network().uploadFile(file, Network.UPLOAD_FILE, 'file');
    // var body = json.decode(res.body);
    return res;
  }

  // // ========= LOG OUT =============
  // static Future logout() async {
  //   var res = await Network().getData('/logout');
  //   // var body = json.decode(res.body);
  //   // return body;
  //   return res;
  // }

  // // ========= SIGN WITH GOOGLE or FACEBOOK
  // static Future registerUser(String name, String email, String avatar) async {
  //   var data = {"name": name, "email": email, "avatar": avatar};
  //   var res = await Network().authData(data, '/registerUser');
  //   var body = json.decode(res.body);
  //   return body;
  // }

  // // ======== UPDATE USER ======
  // static Future updateUser(UserModel userModel) async {
  //   var res = await Network().authData(userModel.toJson(), '/updateUser');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== CHANGE USER ======
  // static Future changePassword(Map data) async {
  //   var res = await Network().authData(data, '/changePassword');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // //=========== UPLOAD AVATAR ==============
  // static Future<String> uploadAvatarImage(File image, String email) async {
  //   try {
  //     var res = await Network().uploadFile(image, '/uploadAvatar', email);
  //     if (res.statusCode == 200) {
  //       var data = await res.stream.bytesToString();
  //       var body = json.decode(data);
  //       return body['path'];
  //     } else {
  //       return '';
  //     }
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // /****************************************************
  //  * FORGET PASSWORD
  //  *
  //  */

  // // ======== SEND CODE ======
  // static Future sendCode(Map data) async {
  //   var res = await Network().authData(data, '/sendCode');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== SEND VERIFY CODE ======
  // static Future verifyCode(Map data) async {
  //   var res = await Network().authData(data, '/verifyCode');
  //   // var body = json.decode(res.body);
  //   return res;
  // }

  // // ======== SEND VERIFY CODE ======
  // static Future resetPassword(Map data) async {
  //   var res = await Network().authData(data, '/resetPassword');
  //   // var body = json.decode(res.body);
  //   return res;
  // }
}
