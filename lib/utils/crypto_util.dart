import 'package:edmonscan/utils/constants.dart';

class CryptoUtil {
  static double satoToBtc(int satoshi) {
    return satoshi / CryptoConf.BITCOIN_DIGIT;
  }

  static int BtcToSato(int btc) {
    return btc * CryptoConf.BITCOIN_DIGIT;
  }
}
