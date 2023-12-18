import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/app/services/api_dio.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AppRepository {
  // ========== GET CALL TOKEN ==================
  static Future<Map<String, dynamic>> getCallToken(
      {required String channelName, required int uid}) async {
    var res = await Network().getAgoraToken(channelName: channelName, uid: uid);
    Logger().i('================= LOGIN WITH CUSTOMER SERVER =============');
    print(res.statusCode);
    Logger().i(res.body);

    var body = json.decode(res.body);
    return body;

    // var result = callback(res);
    // return result;
  }
}
