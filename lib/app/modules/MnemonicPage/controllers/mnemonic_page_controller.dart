import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/bitcoin_service.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:edmonscan/utils/local_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MnemonicPageController extends GetxController {
  //TODO: Implement MnemonicPageController

  final count = 0.obs;
  final loading = true.obs;

  final authCtrl = Get.find<AuthController>();

  BitcoinService bitcoinService = new BitcoinService(
    network: CryptoConf.BITCOIN_NETWORK,
    path: CryptoConf.BITCOIN_PATH,
    password: CryptoConf.BITCOIN_PASSWORD,
  );

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    initWallet();
    loading.value = false;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final _mnemonic = ''.obs;
  String get mnemonic => _mnemonic.value;

  final _mnemonicList = Rx<List<String>>([]);
  List<String> get mnemonicList => _mnemonicList.value;

  final walletAddress = ''.obs;

/****************************************
 * @Auth: geniusdev0813@gmail.com
 * @Date: 2023.10.23
 * @Desc: Generate Mnemonic
 */
  initWallet() async {
    try {
      var res = await bitcoinService.generateMnemonic();
      _mnemonic.value = res.toString();
      Logger().d(mnemonic);
      final arr = mnemonic.split(' ');
      _mnemonicList.value = arr;
      Logger().d(mnemonicList);

      update();
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  /******************************
   * Create Wallet 
   */
  createWallet() async {
    try {
      if (mnemonic == "") return;
      EasyLoading.show();
      final wallet =
          await bitcoinService.createOrRestoreWallet(mnemonic: mnemonic);
      final address = await bitcoinService.getWalletAddress(wallet);
      walletAddress.value = address;

      // final block = await bitcoinService.blockchainInit();

      await bitcoinService.getBalance(wallet);
      authCtrl.updateBTCservice(bitcoinService);

      // SAVE MNEMONIC TO LOCAL
      await storeDataToLocal(
          key: AppLocalKeys.MNEMONIC_CODE,
          value: mnemonic,
          type: StorableDataType.String);

      await authCtrl.updateBtcAddress(address);
      EasyLoading.dismiss();

      update();
      CustomSnackBar.showCustomSnackBar(
          title: "SUCCESS",
          message: "Your BITCOIN wallet is created successfully!");

      Get.offNamed(Routes.HOME);
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  void increment() => count.value++;
}
