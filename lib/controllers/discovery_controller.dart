import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart';
import '../models/selected_item.dart';

class DiscoveryController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  var selectedItems = <SelectedItem>[].obs;
  final selectedImages = <XFile>[].obs;
  final _picker = ImagePicker();

  void addItem(SelectedItem item) {
    selectedItems.add(item);
  }

  void removeItem(int id) {
    selectedItems.removeWhere((item) => item.id == id);
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      selectedImages.add(photo);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
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
    String? completionTime,
    String? offerValidUntil,
    String? serviceCost,
    String? transportationCost,
    String? laborCost,
    String? extraFee,
    String? discountRate,
    String? discountAmount,
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

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/discoveries'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $storedToken',
      });

      // Add basic fields
      Map<String, String> fields = {
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail,
        'discovery': discovery,
        'todo_list': todoList,
        if (noteToCustomer?.isNotEmpty ?? false)
          'note_to_customer': noteToCustomer!,
        if (noteToHandi?.isNotEmpty ?? false) 'note_to_handi': noteToHandi!,
        if (paymentMethod?.isNotEmpty ?? false)
          'payment_method': paymentMethod!,
        if (completionTime?.isNotEmpty ?? false)
          'completion_time': completionTime!,
        if (offerValidUntil?.isNotEmpty ?? false)
          'offer_valid_until': offerValidUntil!,
        if (serviceCost?.isNotEmpty ?? false) 'service_cost': serviceCost!,
        if (transportationCost?.isNotEmpty ?? false)
          'transportation_cost': transportationCost!,
        if (laborCost?.isNotEmpty ?? false) 'labor_cost': laborCost!,
        if (extraFee?.isNotEmpty ?? false) 'extra_fee': extraFee!,
        if (discountRate?.isNotEmpty ?? false) 'discount_rate': discountRate!,
        if (discountAmount?.isNotEmpty ?? false)
          'discount_amount': discountAmount!,
      };

      // Add items array
      if (selectedItems.isNotEmpty) {
        for (var i = 0; i < selectedItems.length; i++) {
          var item = selectedItems[i];
          fields['items[$i][id]'] = item.id.toString();
          fields['items[$i][quantity]'] = item.quantity.toString();
          if (item.customPrice != null) {
            fields['items[$i][custom_price]'] = item.customPrice.toString();
          }
        }
      } else {
        fields['items'] = '[]'; // Empty array if no items selected
      }

      request.fields.addAll(fields);

      // Add images
      if (selectedImages.isNotEmpty) {
        for (var i = 0; i < selectedImages.length; i++) {
          final file = await http.MultipartFile.fromPath(
            'images[]',
            selectedImages[i].path,
          );
          request.files.add(file);
        }
      }

      // Debug prints
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.length}');

      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      print('Response: $jsonResponse');

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          jsonResponse['message'] ?? 'Discovery created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        selectedItems.clear();
        selectedImages.clear();
        return true;
      } else {
        Get.snackbar(
          'Error',
          jsonResponse['message'] ?? 'Failed to create discovery',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error: $e');
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
