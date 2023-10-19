import 'dart:convert';
import 'dart:io';

import 'package:edmonscan/app/services/api.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AppRepository {
  // ========== GET CALL TOKEN ==================
  static Future<Map<String, dynamic>> getCallToken(data) async {
    var res = await Network().authData(data, Network.GET_CALL_TOKEN);
    Logger().i('================= LOGIN WITH CUSTOMER SERVER =============');
    print(res.statusCode);
    Logger().i(res.body);

    var body = json.decode(res.body);
    return body;

    // var result = callback(res);
    // return result;
  }
}
