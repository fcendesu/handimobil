// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:handimobil/views/home.dart';
import 'package:handimobil/views/login_page.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
        'password': password,
      };
      print("öncesi");
      var response = await http.post(
        Uri.parse('$url/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      print("sonrası");

      if (response.statusCode == 201) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const Home());
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
      };
      print("öncesi");
      var response = await http.post(
        Uri.parse('$url/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      print("sonrası");

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const Home());
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> validateToken() async {
    try {
      var storedToken = box.read('token');
      print(storedToken);
      if (storedToken == null) {
        Get.offAll(() => const LoginPage());
        return;
      }

      var response = await http.get(
        Uri.parse('$url/token/validate'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      print(json.decode(response.body));

      if (response.statusCode == 200) {
        Get.offAll(() => const Home());
      } else {
        box.remove('token');
        Get.offAll(() => const LoginPage());
      }
    } catch (e) {
      print(e.toString());
      Get.offAll(() => const LoginPage());
    }
  }
}
