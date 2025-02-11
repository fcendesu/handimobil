// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;

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
        print(json.decode(response.body));
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
