import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_sql/presentation/controller/barang_controller.dart';
import 'package:crud_sql/model/Barang.dart';

class BarangPage extends StatelessWidget {
  const BarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BarangController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Home'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Barang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.listBarang.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.listBarang.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.getBarang,
                    child: ListView(
                      children: const [
                        SizedBox(height: 140),
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Center(child: Text('Belum ada data barang')),
                        Center(child: Text('Tekan tombol + untuk menambahkan barang')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.getBarang,
                  child: ListView.builder(
                    itemCount: controller.listBarang.length,
                    itemBuilder: (context, index) {
                      final barang = controller.listBarang[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            barang.nama,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Harga: ${_formatRupiah(barang.harga)}\nStok: ${barang.stok}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showBarangForm(context, controller, barang: barang);
                              } else if (value == 'delete') {
                                _confirmDelete(context, controller, barang);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.delete_outline, color: Colors.red),
                                  title: Text('Hapus'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBarangForm(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Barang'),
      ),
    );
  }

  Future<void> _showBarangForm(
    BuildContext context,
    BarangController controller, {
    Barang? barang,
  }) async {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: barang?.nama ?? '');
    final hargaController = TextEditingController(
      text: barang == null ? '' : barang.harga.toString(),
    );
    final stokController = TextEditingController(
      text: barang == null ? '' : barang.stok.toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(barang == null ? 'Tambah Barang' : 'Edit Barang'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateNumber(value, 'Harga'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: stokController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stok',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateNumber(value, 'Stok'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final data = Barang(
                  id: barang?.id,
                  nama: namaController.text.trim(),
                  harga: int.parse(hargaController.text.trim()),
                  stok: int.parse(stokController.text.trim()),
                );

                Navigator.of(dialogContext).pop();
                if (barang == null) {
                  await controller.tambahBarang(data);
                } else {
                  await controller.ubahBarang(data);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    namaController.dispose();
    hargaController.dispose();
    stokController.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BarangController controller,
    Barang barang,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Barang'),
        content: Text('Yakin ingin menghapus barang "${barang.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && barang.id != null) {
      await controller.hapusBarang(barang.id!, barang.nama);
    }
  }

  String? _validateNumber(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    final number = int.tryParse(value.trim());
    if (number == null || number < 0) {
      return '$label harus berupa angka 0 atau lebih';
    }
    return null;
  }

  String _formatRupiah(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString()}';
  }
}
