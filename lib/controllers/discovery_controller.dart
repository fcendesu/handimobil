import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';

class DiscoveryController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> storeDiscovery({
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String discovery,
    required String todoList,
    String? noteToCustomer,
    String? noteToHandi,
    String? paymentMethod,
  }) async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      var response = await http.post(
        Uri.parse('$url/discoveries'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: {
          'customer_name': customerName,
          'customer_phone': customerPhone,
          'customer_email': customerEmail,
          'discovery': discovery,
          'todo_list': todoList,
          'note_to_customer': noteToCustomer,
          'note_to_handi': noteToHandi,
          'payment_method': paymentMethod,
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Discovery created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      print(json.decode(response.body));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
