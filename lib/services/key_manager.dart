import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';
import 'package:secure_enclave/secure_enclave.dart';
import 'package:solosafe/services/shared_pref.dart';
import 'package:wallet_kit/wallet_kit.dart';
import 'package:web3dart/web3dart.dart';

abstract class SoloSafeSecureEnclaveInterface {
  Future<SecureEnclave> getSecureEnclave();
}

class SoloSafeSecureEnclave implements SoloSafeSecureEnclaveInterface {
  final tag = 'keys';
  final password = 'password';
  SecureEnclave? secureEnclave;

  addEnclaveTag() async {
    secureEnclave ??= SecureEnclave();
    final isSecureEnclaveCreated =
        (await secureEnclave?.isKeyCreated(tag: tag))?.value ?? false;
    if (isSecureEnclaveCreated) {
      return;
    } else {
      final res = await secureEnclave?.generateKeyPair(
          accessControl: AccessControlModel(
              tag: tag,
              password: password,
              options: [
            AccessControlOption.applicationPassword,
            AccessControlOption.privateKeyUsage
          ]));
      if (res?.error != null) {
        throw Exception('Error adding secure enclave tag');
      }
    }
  }

  @override
  Future<SecureEnclave> getSecureEnclave() async {
    await addEnclaveTag();
    return secureEnclave!;
  }

  Future<String> encryptValue(String value) async {
    final secureEnclave = await getSecureEnclave();
    final seEncryptedValue =
        (await secureEnclave.encrypt(message: value, tag: tag)).value;
    if (seEncryptedValue == null) {
      throw Exception(
          'Error encrypting value, unable to encrypt value with secure enclave');
    }
    return hex.encode(seEncryptedValue);
  }

  Future<String> decryptValue(String value) async {
    final secureEnclave = await getSecureEnclave();
    final seEncryptedValue = (await secureEnclave.decrypt(
            message: Uint8List.fromList(hex.decode(value)), tag: tag))
        .value;
    if (seEncryptedValue == null) {
      throw Exception(
          'Error decrypting value, unable to decrypt value with secure enclave');
    }
    return seEncryptedValue;
  }
}

String enclaveKey() {
  return 'enclaveKey';
}

Future<String> enclavePassword() async {
  return 'enclavePassword';
}

// This function generates the keys, saves them and returns the mnemonic for the user to save
Future<String> generateSoloSafeKeys({String mnemonic = ''}) async {
  // Generate the mnemonic
  mnemonic = mnemonic == '' ? bip39.generateMnemonic() : mnemonic;

  // Generate the ETH private and public keys
  var seed = bip39.mnemonicToSeedHex(mnemonic);
  var privateKey = EthPrivateKey.fromHex(seed);
  final hexPrivateKey = privateKey.privateKeyInt.toRadixString(16);
  final hexPublicKey = privateKey.address.hex;

  // Generate the STRK private and public keys
  final (strkHexPrivateKey, strkHexAddress) = await generateStrkKeys(mnemonic);

  // Save the keys
  await saveKeys(
      hexPrivateKey, hexPublicKey, mnemonic, strkHexPrivateKey, strkHexAddress);
  return mnemonic;
}

Future<(String, String)> generateStrkKeys(String mnemonic) async {
  final strkPrivateKey = await WalletService.derivePrivateKey(
      seedPhrase: mnemonic, derivationIndex: 0);
  final strkAddress =
      await WalletService.computeAddress(privateKey: strkPrivateKey);
  return (strkPrivateKey.toHexString(), strkAddress.toHexString());
}

Future<void> saveKeys(String privateKey, String publicKey, String mnemonic,
    String strkHexPrivateKey, String strkHexAddress) async {
  final solosafeSecureEnclave = SoloSafeSecureEnclave();
  final encryptedPrivateKey =
      await solosafeSecureEnclave.encryptValue(privateKey);
  final encryptedPublicKey =
      await solosafeSecureEnclave.encryptValue(publicKey);
  final encryptedMnemonic = await solosafeSecureEnclave.encryptValue(mnemonic);
  final encryptedStrkPrivateKey =
      await solosafeSecureEnclave.encryptValue(strkHexPrivateKey);
  final encryptedStrkAddress =
      await solosafeSecureEnclave.encryptValue(strkHexAddress);

  // Write the private key
  await AppPrefSecureStorage.writePublicKey(encryptedPublicKey);
  // Write the private key
  await AppPrefSecureStorage.writePrivateKey(encryptedPrivateKey);
  // Write the mnemonic key
  await AppPrefSecureStorage.writeMnemonic(encryptedMnemonic);
  // Write the startknet private key
  await AppPrefSecureStorage.writeStrkPrivateKey(encryptedStrkPrivateKey);
  // Write the starknet address
  await AppPrefSecureStorage.writeStrkAddress(encryptedStrkAddress);
}

Future<(String, String)> getDecryptedPublicKeys() async {
  final solosafeSecureEnclave = SoloSafeSecureEnclave();
  final encryptedPublicKey = await AppPrefSecureStorage.readPublicKey ?? '';
  final encryptedStrkAddress = await AppPrefSecureStorage.readStrkAdd ?? '';
  final publicKey =
      await solosafeSecureEnclave.decryptValue(encryptedPublicKey);
  final strkAddress =
      await solosafeSecureEnclave.decryptValue(encryptedStrkAddress);
  return (publicKey, strkAddress);
}
