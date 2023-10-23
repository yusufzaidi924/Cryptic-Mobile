import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MnemonicPageController extends GetxController {
  //TODO: Implement MnemonicPageController

  final count = 0.obs;
  final loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    generateMnemonicHandler();
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

/****************************************
 * @Auth: geniusdev0813@gmail.com
 * @Date: 2023.10.23
 * @Desc: Generate Mnemonic
 */
  generateMnemonicHandler() async {
    var res = await Mnemonic.create(WordCount.Words12);
    _mnemonic.value = res.toString();
    Logger().d(mnemonic);
    if (mnemonic != null && mnemonic != '') {
      final arr = mnemonic.split(' ');
      _mnemonicList.value = arr;
      Logger().d(mnemonicList);
    }
    update();
  }

  void increment() => count.value++;
}
