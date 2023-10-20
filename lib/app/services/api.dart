import 'dart:convert';
import 'package:edmonscan/utils/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  static String BASE_URL = 'http://3.19.101.55:3300/';
  // static String BASE_URL = 'http://192.168.2.4:3300/';

  static String LOGIN = "login";
  static String REGISTER = 'signup';
  static String RESEND_OTP_CODE = 'resendCode';
  static String VERIFY_CODE = 'verifyCode';
  static String SAVE_USER_DETAIL = 'saveUserDetail';
  static String SEND_INVITE_SMS = 'sendInviteSMS';
  static String GET_CALL_TOKEN = 'app/getCallToken';

  static String UPLOAD_FILE = 'uploadFile';

  static String SAVE_REGISTER_DETAIL = 'save_register_detail';

  int timeout = 10;
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  Future _getToken() async {
    token = await getDataInLocal(
        key: AppLocalKeys.TOKEN, type: StorableDataType.String);
  }

  authData(data, apiUrl) async {
    var fullUrl = Uri.parse(BASE_URL + apiUrl);
    Logger().i(fullUrl);
    return await http
        .post(fullUrl, body: jsonEncode(data), headers: _setHeaders())
        .timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  Future<Response> getDataURL(apiUrl, {Map<String, dynamic>? params}) async {
    // var fullUrl = BASE_URL + apiUrl;
    String fullPath = apiUrl;
    if (params != null) {
      fullPath += "?";
      int index = 0;
      params.forEach((k, v) {
        index++;
        fullPath += k.toString() + "=" + v.toString();
        if (index < params.length) fullPath += "&";
      });
    }
    var fullUrl = Uri.parse(fullPath);

    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders()).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  Future<Response> getData(apiUrl, {Map<String, dynamic>? params}) async {
    String fullPath = BASE_URL + apiUrl;

    print('fullpath');
    print(fullPath);
    if (params != null) {
      fullPath += "?";
      int index = 0;
      params.forEach((k, v) {
        index++;
        fullPath += k.toString() + "=" + v.toString();
        if (index < params.length) fullPath += "&";
      });
    }
    var fullUrl = Uri.parse(fullPath);

    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders()).timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  postData(data, apiUrl) async {
    // var fullUrl = BASE_URL + apiUrl;
    var fullUrl = Uri.parse(BASE_URL + apiUrl);

    await _getToken();
    return await http
        .post(fullUrl, body: json.encode(data), headers: _setHeaders())
        .timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
  }

  uploadFile(file, apiUrl, name) async {
    // var fullUrl = Uri.parse(BASE_URL + apiUrl);
    var fullUrl = Uri.parse(BASE_URL + apiUrl);
    String fileName = file.path.split('/').last;
    await _getToken();

    var request = http.MultipartRequest('POST', fullUrl);
    request.files.add(
      await http.MultipartFile.fromPath(
        name ?? 'file',
        file.path,
        filename: fileName,
      ),
    );

    request.headers.addAll(_setHeaders());
    request.headers['Content-Type'] = "multipart/form-data";
    request.fields['name'] = name;
    // request.fields['deviceid'] = deviceid;
    // request.fields['letter'] = letter;
    // request.fields['comment'] = commentCtrl.text;

    // var res = await request.send().then((value) {
    //   print(value.toString());
    // }).catchError((onError) {
    //   //------------ Dismiss Porgress Dialog  -------------------
    //   print(onError.toString());
    // });

    // http.Response response =
    //     await http.Response.fromStream(await request.send());

    // print("Result: ${response.body}");
    // return response;

    print(request.headers);

    return await request.send();
    // .then((res) async {
    //   print(res.headers);
    //   print(res.statusCode);
    //   print(await res.stream.bytesToString());
    // }).catchError((e) {
    //   print(e);
    // });
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
