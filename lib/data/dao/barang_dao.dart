import 'package:crud_sql/data/database/db_helper.dart';
import 'package:crud_sql/model/Barang.dart';
class BarangDao {
  final DbHelper _dbHelper;

  BarangDao({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  static const String _table = DbHelper.tableBarang;

  // CREATE: menyimpan barang baru.
  Future<int> insert(Barang barang) async {
    final db = await _dbHelper.database;
    return db.insert(_table, barang.toMap());
  }

  // READ: mengambil seluruh data barang.
  Future<List<Barang>> getAll() async {
    final db = await _dbHelper.database;
    final barang = await db.query(_table, orderBy: 'nama ASC');
    return barang.map(Barang.fromMap).toList();
  }

  // UPDATE: memperbarui barang berdasarkan ID.
  Future<int> update(Barang barang) async {
  final db = await _dbHelper.database;
  return db.update(
    _table,
    barang.toMap(),
    where: 'id = ?',
    whereArgs: [barang.id],
  );
}

  // DELETE: menghapus barang berdasarkan ID.
  Future<int> delete(int id) async {
  final db = await _dbHelper.database;
  return db.delete(
    _table,
    where: 'id = ?',
    whereArgs: [id],
  );
}
}
