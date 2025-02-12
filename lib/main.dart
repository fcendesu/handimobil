import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handimobil/views/login_page.dart';
import 'package:handimobil/views/home.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HandiMobil',
      home: token == null ? const LoginPage() : const Home(),
    );
  }
}
