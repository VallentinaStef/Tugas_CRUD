import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _dbName = 'gudang.db';
  static const String tableBarang = 'barang';
  static const int _dbVersion = 1;

  Database? db;

  Future<Database> get database async => db ??= await _open();

  Future<Database> _open() async {
    final directory = await getDatabasesPath();

    return openDatabase(
      '$directory/$_dbName',
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableBarang (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            harga INTEGER NOT NULL,
            stok INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
