import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPrefSecureStorage {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const _privateKey = 'private_key';
  static const _publicKey = 'public_key';
  static const _mnemonic = 'mnemonic';
  static const _dbPassoword = 'db_password';
  static const _strkPrivateKey = 'strkPrivateKey';
  static const _strkAddress = 'strkAddress';

  // set the public key to the secured pref storage
  static Future<void> writePublicKey(String pbk) async {
    await _secureStorage.write(key: _publicKey, value: pbk);
  }

  // set the private key to the secured pref storage
  static Future<void> writePrivateKey(String pk) async {
    await _secureStorage.write(key: _privateKey, value: pk);
  }

  // set the mnemonic to the secured pref storage
  static Future<void> writeMnemonic(String nm) async {
    await _secureStorage.write(key: _mnemonic, value: nm);
  }

  // set the database password
  static Future<void> writeDbPassword(String passphrase) async {
    await _secureStorage.write(key: _dbPassoword, value: passphrase);
  }

  // set the database password
  static Future<void> writeStrkPrivateKey(String strkPk) async {
    await _secureStorage.write(key: _strkPrivateKey, value: strkPk);
  }

  // set the database password
  static Future<void> writeStrkAddress(String strkAddr) async {
    await _secureStorage.write(key: _strkAddress, value: strkAddr);
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

  // get the starknet address key to the secured pref storage
  static Future<String?> get readStrkAdd async {
    return await _secureStorage.read(
      key: _strkAddress,
    );
  }

  // get the starknet address key to the secured pref storage
  static Future<String?> get readStrkPrivateKey async {
    return await _secureStorage.read(
      key: _strkPrivateKey,
    );
  }

  /// Method to remove data
  static Future<void> removeAll() async {
    await _secureStorage.delete(key: _privateKey);
    await _secureStorage.delete(key: _publicKey);
    await _secureStorage.delete(key: _mnemonic);
  }
}
