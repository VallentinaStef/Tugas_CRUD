import 'package:get/get.dart';
import 'package:crud_sql/data/database/db_helper.dart';
import 'package:crud_sql/data/dao/barang_dao.dart';
import 'package:crud_sql/data/repo/barang_repo.dart';
import 'package:crud_sql/presentation/controller/barang_controller.dart';
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DbHelper>(DbHelper(), permanent: true);
    Get.put<BarangDao>(
      BarangDao(dbHelper: Get.find<DbHelper>()),
      permanent: true,
    );
    Get.put<BarangRepo>(
      BarangRepoImpl(dao: Get.find<BarangDao>()),
      permanent: true,
    );
    Get.put<BarangController>(
      BarangController(repo: Get.find<BarangRepo>()),
      permanent: true,
    );
  }
}
