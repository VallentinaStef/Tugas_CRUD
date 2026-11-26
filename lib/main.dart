import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crud_sql/presentation/pages/barang_page.dart';
import 'package:crud_sql/app_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gudang Barang',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      home: const BarangPage(),
    );
  }
}
