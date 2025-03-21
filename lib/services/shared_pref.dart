import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPrefSecureStorage {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const _privateKey = 'private_key';
  static const _publicKey = 'public_key';
  static const _mnemonic = 'mnemonic';
  static const _dbPassoword = 'db_password';

  // set the public key to the secured pref storage
  static Future<void> writePublicKey(bool hasSetBiometric) async {
    await _secureStorage.write(
        key: biometric, value: hasSetBiometric.toString());
  }

  static Future<void> writeDbPassword(String passphrase) async {
    return await _secureStorage.write(key: _dbPassoword, value: passphrase);
  }

  // get the public key to the secured pref storage
  static Future<String?> get readPublicKey async {
    return await _secureStorage.read(
      key: _publicKey,
    );
  }

  // get the private key to the secured pref storage
  static Future<String?> get readPrivateKey async {
    return await _secureStorage.read(
      key: _privateKey,
    );
  }

  // get the private key to the secured pref storage
  static Future<String?> get readMnemonic async {
    return await _secureStorage.read(
      key: _mnemonic,
    );
  }

  // get the private key to the secured pref storage
  static Future<String?> get readDbPassword async {
    return await _secureStorage.read(
      key: _dbPassoword,
    );
  }

  /// Method to remove data
  static Future<void> removeAll() async {
    await _secureStorage.delete(key: _privateKey);
    await _secureStorage.delete(key: _publicKey);
    await _secureStorage.delete(key: _mnemonic);
  }
}
