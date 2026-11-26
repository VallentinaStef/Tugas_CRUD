import 'package:crud_sql/data/dao/barang_dao.dart';
import 'package:crud_sql/model/Barang.dart';

abstract class BarangRepo {
  Future<List<Barang>> getAll();
  Future<int> insert(Barang barang);
  Future<int> update(Barang barang);
  Future<int> delete(int id);
}

class BarangRepoImpl implements BarangRepo {
  final BarangDao dao;

  BarangRepoImpl({required this.dao});

  @override
  Future<List<Barang>> getAll() {
    return dao.getAll();
  }

  @override
  Future<int> insert(Barang barang) {
    return dao.insert(barang);
  }

  @override
  Future<int> update(Barang barang) {
    return dao.update(barang);
  }

  @override
  Future<int> delete(int id) {
    return dao.delete(id);
  }
}
