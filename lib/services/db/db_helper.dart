import 'package:solosafe/models/local_db/utxos.dart';
import 'package:solosafe/services/shared_pref.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

/// DatabaseService with Singleton pattern and encrypted local storage
class DatabaseService {
  // Create a single instance (Singleton)
  static final DatabaseService _instance = DatabaseService._internal();

  static Database? _db;
  static const _dbName = 'transactions.db';
  static const _dbVersion = 1;

  // Private constructor
  DatabaseService._internal();

  // Factory constructor to return the single instance
  factory DatabaseService() {
    return _instance;
  }

  /// Get the database password from secure storage or generate a new one
  Future<String> _getOrGeneratePassword() async {
    String? passphrase = await AppPrefSecureStorage.readDbPassword;
    if (passphrase == null) {
      passphrase = _generateSecureKey(32);
      await AppPrefSecureStorage.writeDbPassword(passphrase);
    }
    return passphrase;
  }

  /// Generate a random secure key for database encryption
  String _generateSecureKey(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    return List.generate(
        length,
        (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) %
            chars.length]).join();
  }

  /// Getter for the database instance (initializes if not available)
  Future<Database> get database async {
    if (_db != null) return _db!;
    return await _initDB();
  }

  /// Initialize the encrypted database
  Future<Database> _initDB() async {
    final dbPath = join(await getDatabasesPath(), _dbName);
    final passphrase = await _getOrGeneratePassword();

    _db = await openDatabase(
      dbPath,
      password: passphrase,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Create UTXOs table
        await db.execute('''
          CREATE TABLE utxos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            txId TEXT NOT NULL,
            outputIndex INTEGER NOT NULL,
            address TEXT NOT NULL,
            amount REAL NOT NULL,
            timestamp INTEGER NOT NULL,
            scriptPubKey TEXT,
            spent INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }

  // ========== CRUD Methods ==========

  /// Insert a new UTXO into the database
  Future<void> insertUtxo(Utxo utxo) async {
    final db = await database;
    await db.insert('utxos', utxo.toMap());
  }

  /// Get all unspent UTXOs (spent = 0)
  Future<List<Utxo>> getUnspentUtxos() async {
    final db = await database;
    final maps = await db.query('utxos', where: 'spent = ?', whereArgs: [0]);
    return maps.map((e) => Utxo.fromMap(e)).toList();
  }

  /// Mark a UTXO as spent by txId and outputIndex
  Future<void> markUtxoAsSpent(String txId, int outputIndex) async {
    final db = await database;
    await db.update(
      'utxos',
      {'spent': 1},
      where: 'txId = ? AND outputIndex = ?',
      whereArgs: [txId, outputIndex],
    );
  }

  /// Delete all UTXOs (reset the local database if needed)
  Future<void> deleteAllUtxos() async {
    final db = await database;
    await db.delete('utxos');
  }
}
