import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';

class ItemController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> storeItem({
    required String item,
    required String brand,
    required String price,
  }) async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      var response = await http.post(
        Uri.parse('$url/item/store'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: {
          'item': item,
          'brand': brand,
          'price': price,
        },
      );

      print(json.decode(response.body));

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Item created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
