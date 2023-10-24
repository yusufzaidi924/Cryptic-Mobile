/****************************************
 * @Auth: geniusdev0813@gmail.com
 * @Date: 2023.10.23
 * @Desc: BITCOIN SERVICE
 */

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:logger/logger.dart';

class BitcoinService {
  Network network = Network.Testnet;
  String path = "m/84'/1'/0'";
  String password = "password";

  String? mnemonic;
  Wallet? wallet;
  String? walletAddress;
  int balance = 0;
  Blockchain? blockchain;

  BitcoinService(
      {Network network = Network.Testnet,
      path = "m/84'/1'/0'",
      password = "password"}) {
    this.network = network;
    this.path = path;
    this.password = password;
  }

  Future<String> generateMnemonic() async {
    var res = await Mnemonic.create(WordCount.Words12);
    String code = res.toString();

    return code;
  }

  Future<Wallet> createOrRestoreWallet({
    required String mnemonic,
    // required Network network,
    // String? password,
    // required String path
  }) async {
    try {
      this.mnemonic = mnemonic;

      final descriptors = await getDescriptors(mnemonic);
      final block = await blockchainInit();
      final res = await Wallet.create(
          descriptor: descriptors[0],
          changeDescriptor: descriptors[1],
          network: this.network,
          databaseConfig: const DatabaseConfig.memory());
      wallet = res;
      await syncWallet(block);
      return res;
    } on Exception catch (e) {
      print("Error: ${e.toString()}");
      throw e;
    }
  }

  Future<String> getWalletAddress(Wallet wallet) async {
    var addressInfo = await getNewAddress(wallet);
    walletAddress = addressInfo.address;
    print('🎁 Wallet Address : $walletAddress');
    return addressInfo.address;
  }

  Future<AddressInfo> getNewAddress(Wallet wallet) async {
    final res = await wallet.getAddress(addressIndex: const AddressIndex());
    print('🎁 Wallet New Address : ${res.address}');

    return res;
  }

  Future<List<Descriptor>> getDescriptors(String mnemonicStr) async {
    final descriptors = <Descriptor>[];
    try {
      for (var e in [KeychainKind.External, KeychainKind.Internal]) {
        final mnemonic = await Mnemonic.fromString(mnemonicStr);
        final descriptorSecretKey = await DescriptorSecretKey.create(
          network: this.network,
          mnemonic: mnemonic,
        );
        final descriptor = await Descriptor.newBip84(
            secretKey: descriptorSecretKey, network: this.network, keychain: e);
        descriptors.add(descriptor);
      }
      return descriptors;
    } on Exception catch (e) {
      print("Error : ${e.toString()}");
      throw e;
    }
  }

  Future<Blockchain> blockchainInit() async {
    try {
      final _blockchain = await Blockchain.create(
          config: BlockchainConfig.electrum(
              config: ElectrumConfig(
                  stopGap: 10,
                  timeout: 5,
                  retry: 5,
                  url: "ssl://electrum.blockstream.info:60002",
                  validateDomain: false)));
      blockchain = _blockchain;
      return _blockchain;
    } on Exception catch (e) {
      print("Error : ${e.toString()}");
      throw e;
    }
  }

  Future<int> getBalance(Wallet wallet) async {
    final balanceObj = await wallet.getBalance();
    balance = balanceObj.total;

    print("💖💖💖 Wallet Balance: ${balance} , ${balanceObj.confirmed}");
    return balanceObj.total;
  }

  /*****************************
   * Send BTC to other address
   */
  Future<Transaction> sendTx(String addressStr, int amount) async {
    if (wallet == null)
      throw "Your BTC wallet is not loaded yet. Please restart app";
    try {
      final blockchain = await blockchainInit();
      final txBuilder = TxBuilder();
      final address = await Address.create(address: addressStr);
      final script = await address.scriptPubKey();
      final txBuilderResult = await txBuilder
          .addRecipient(script, amount)
          .feeRate(1.0)
          .finish(wallet!);
      final sbt = await wallet!.sign(psbt: txBuilderResult.psbt);
      final tx = await sbt.extractTx();
      await blockchain.broadcast(tx);
      print("🎉🎉🎉 Successfully broadcast $amount Sats to $addressStr 🎉🎉🎉");
      return tx;
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  syncWallet(Blockchain blockchain) async {
    wallet!.sync(blockchain);
  }
}
