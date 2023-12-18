import 'package:edmonscan/app/data/models/crypto_model.dart';

import '../services/api_dio.dart';

const apiKey = '5f36825e-a570-4ba5-94ce-b74666b1399b';

class CryptoRepositories extends Api {
  Future<List<CryptoModel>> getListLatestCrypto() async {
    var response = await request(
        "https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest",
        Method.get,
        params: {
          "start": 1,
          "limit": 50,
          "convert": "USD"
        },
        headerAddition: {
          "X-CMC_PRO_API_KEY": apiKey,
        });
    return (response.data["data"] as List).map((e) {
      return CryptoModel.fromJson(e);
    }).toList();
  }
}
