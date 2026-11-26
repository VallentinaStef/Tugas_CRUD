import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_sql/data/repo/barang_repo.dart';
import 'package:crud_sql/model/Barang.dart';

class BarangController extends GetxController {
  final BarangRepo repo;

  BarangController({required this.repo});

  final RxList<Barang> listBarang = <Barang>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBarang();
  }

  Future<void> getBarang() async {
    isLoading.value = true;
    try {
      final data = await repo.getAll();
      listBarang.assignAll(data);
    } catch (e) {
      _showMessage('Error', 'Gagal mengambil data: $e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> tambahBarang(Barang barang) async {
    try {
      await repo.insert(barang);
      await getBarang();
      _showMessage(
        'Sukses',
        'Data ${barang.nama} berhasil ditambahkan',
        Colors.green,
      );
    } catch (e) {
      _showMessage('Error', 'Gagal menambahkan data: $e', Colors.red);
    }
  }

  Future<void> ubahBarang(Barang barang) async {
    try {
      await repo.update(barang);
      await getBarang();

      Get.snackbar(
        "Sukses",
        "Data ${barang.nama} berhasil diperbarui",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui data: $e");
    }
  }

  Future<void> hapusBarang(int id, String nama) async {
  try {
    await repo.delete(id);
    await getBarang();

    Get.snackbar(
      "Sukses",
      "Data $nama berhasil dihapus",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar("Error", "Gagal menghapus data: $e");
  }
}

  void _showMessage(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }
}
