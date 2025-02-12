import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';

class ItemController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  var items = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

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
        fetchItems(); // Add this line to refresh the list
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      var response = await http.get(
        Uri.parse('$url/item/index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        items.value = List<Map<String, dynamic>>.from(
            json.decode(response.body)['items']);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> updateItem({
    required int id,
    required String item,
    required String brand,
    required String price,
  }) async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      var response = await http.put(
        Uri.parse('$url/item/update/$id'),
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

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Item updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchItems();
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      var response = await http.delete(
        Uri.parse('$url/item/destroy/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Item deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchItems();
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
