import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/crypto_model.dart';
import 'package:edmonscan/app/repositories/crypto_repository.dart';
import 'package:get/get.dart';

class TrendingPageController extends GetxController {
  List<CryptoModel> listCrypto = [];
  bool isGetCryptoLoading = false;
  final CryptoRepositories _cryptoRepositories = CryptoRepositories();
  @override
  void onInit() {
    _getData();
    super.onInit();
  }

  _getData() async {
    try {
      isGetCryptoLoading = true;
      update();
      listCrypto = await _cryptoRepositories.getListLatestCrypto();
      isGetCryptoLoading = false;
      update();
    } catch (e) {
      isGetCryptoLoading = false;
      update();
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }
}
