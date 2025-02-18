import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handimobil/views/login_page.dart';
import 'package:handimobil/views/home.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handimobil/controllers/authentication.dart';
import 'bindings/app_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'HandiMobil',
    initialBinding: AppBinding(),
    home: InitialScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HandiMobil',
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final AuthenticationController authController =
      Get.put(AuthenticationController());

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    // Add a small delay to ensure GetX is properly initialized
    await Future.delayed(Duration(milliseconds: 100));
    await authController.validateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
