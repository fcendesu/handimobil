import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';
import '../models/selected_item.dart';

class DiscoveryController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  var selectedItems = <SelectedItem>[].obs;

  void addItem(SelectedItem item) {
    selectedItems.add(item);
  }

  void removeItem(int id) {
    selectedItems.removeWhere((item) => item.id == id);
  }

  Future<bool> storeDiscovery({
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

      if (storedToken == null) {
        Get.snackbar(
          'Error',
          'Not authenticated',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Create the request body with items as an empty array by default
      Map<String, dynamic> body = {
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail,
        'discovery': discovery,
        'todo_list': todoList,
        'items': [], // Initialize empty array
        if (noteToCustomer?.isNotEmpty ?? false)
          'note_to_customer': noteToCustomer!,
        if (noteToHandi?.isNotEmpty ?? false) 'note_to_handi': noteToHandi!,
        if (paymentMethod?.isNotEmpty ?? false)
          'payment_method': paymentMethod!,
      };

      // Add items if there are any selected
      if (selectedItems.isNotEmpty) {
        body['items'] = selectedItems.map((item) => item.toJson()).toList();
      }

      print('Request body: ${json.encode(body)}'); // Debug print

      var response = await http.post(
        Uri.parse('$url/discoveries'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Discovery created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        selectedItems.clear();
        return true;
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to create discovery',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error: $e'); // Debug print
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
