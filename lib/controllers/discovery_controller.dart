import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // Add this import
import '../constants/constants.dart';
import '../models/selected_item.dart';

class DiscoveryController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  final existingImages = <String>[].obs;
  final selectedItems = <SelectedItem>[].obs;
  final selectedImages = <XFile>[].obs;
  final _picker = ImagePicker();

  var discoveries = <Map<String, dynamic>>[].obs;
  var isLoadingList = false.obs;
  var isLoadingDetails = false.obs;
  var currentDiscovery = Rxn<Map<String, dynamic>>();
  var isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDiscoveries();
  }

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

  Future<void> fetchDiscoveries() async {
    try {
      isLoadingList.value = true;
      var storedToken = box.read('token');

      if (storedToken == null) {
        Get.snackbar(
          'Error',
          'Not authenticated',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var response = await http.get(
        Uri.parse('$url/discoveries/list'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        discoveries.value =
            List<Map<String, dynamic>>.from(jsonResponse['data']);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch discoveries',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching discoveries',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> fetchDiscoveryDetails(int id) async {
    try {
      isLoadingDetails.value = true;
      var storedToken = box.read('token');

      if (storedToken == null) {
        Get.snackbar('Error', 'Not authenticated',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      var response = await http.get(
        Uri.parse('$url/discoveries/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        currentDiscovery.value = jsonResponse['data'];

        // Clear and update existing images
        existingImages.clear();
        if (jsonResponse['data']['image_urls'] != null) {
          List<dynamic> urls = jsonResponse['data']['image_urls'];
          existingImages.addAll(urls.map((url) => url.toString()));
        }

        // Debug print the image URLs
        print('Image URLs: ${existingImages}');
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch discovery details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching discovery details',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<bool> storeDiscovery({
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String discovery,
    required String todoList,
    String? address, // Add this parameter
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
        if (address?.isNotEmpty ?? false) 'address': address!, // Add this field
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

  Future<bool> updateDiscovery(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      var storedToken = box.read('token');

      if (storedToken == null) {
        Get.snackbar('Error', 'Not authenticated',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/discoveries/$id'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $storedToken',
      });

      request.fields['_method'] = 'PUT';

      // Handle basic fields from data
      data.remove('items'); // Remove items from data to handle separately
      request.fields.addAll(
        data.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      );

      // Format items like in storeDiscovery
      if (selectedItems.isNotEmpty) {
        for (var i = 0; i < selectedItems.length; i++) {
          var item = selectedItems[i];
          request.fields['items[$i][id]'] = item.id.toString();
          request.fields['items[$i][quantity]'] = item.quantity.toString();
          if (item.customPrice != null) {
            request.fields['items[$i][custom_price]'] =
                item.customPrice.toString();
          }
        }
      } else {
        request.fields['items'] = '[]';
      }

      // Debug print
      print('Items data sent: ${request.fields}');

      // Handle images
      if (selectedImages.isNotEmpty) {
        for (var image in selectedImages) {
          final file = await http.MultipartFile.fromPath(
            'images[]',
            image.path,
          );
          request.files.add(file);
        }
      }

      // Handle removed images
      final currentImages = existingImages;
      final originalImages =
          currentDiscovery.value?['image_urls'] as List<dynamic>? ?? [];
      final removedImages = originalImages
          .where((url) => !currentImages.contains(url))
          .map((url) => url.toString())
          .toList();

      if (removedImages.isNotEmpty) {
        request.fields['remove_images'] = jsonEncode(removedImages);
      }

      // Debug prints
      print('Request URL: ${request.url}');
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.length}');

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseData');

      final jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        if (jsonResponse['data']['image_urls'] != null) {
          existingImages.value =
              List<String>.from(jsonResponse['data']['image_urls']);
        }
        selectedImages.clear();

        Get.snackbar(
          'Success',
          'Discovery updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          jsonResponse['message'] ?? 'Failed to update discovery',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error updating discovery: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating discovery',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDiscoveryStatus(int id, String status) async {
    try {
      var storedToken = box.read('token');
      if (storedToken == null) {
        Get.snackbar(
          'Error',
          'Not authenticated',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await http.patch(
        Uri.parse('$url/discoveries/$id/status'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: json.encode({'status': status}),
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Update the current discovery status
        if (currentDiscovery.value != null) {
          currentDiscovery.value = {
            ...currentDiscovery.value!,
            'status': status,
            'updated_at': jsonResponse['data']['updated_at'],
          };
        }

        // Refresh the discoveries list
        await fetchDiscoveries();

        Get.snackbar(
          'Success',
          'Status updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorResponse = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorResponse['message'] ?? 'Failed to update status',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating status: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating status',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add getter for status options
  List<String> get statusOptions => [
        'pending',
        'in_progress',
        'completed',
        'cancelled',
      ];

  double calculateTotalCost() {
    final discovery = currentDiscovery.value;
    if (discovery == null) return 0.0;

    final costs = discovery['costs'] ?? {};

    double total = 0.0;

    // Add all costs
    total += double.tryParse(costs['service_cost']?.toString() ?? '0') ?? 0.0;
    total +=
        double.tryParse(costs['transportation_cost']?.toString() ?? '0') ?? 0.0;
    total += double.tryParse(costs['labor_cost']?.toString() ?? '0') ?? 0.0;
    total += double.tryParse(costs['extra_fee']?.toString() ?? '0') ?? 0.0;

    // Add items total
    if (discovery['items'] != null) {
      for (var item in discovery['items']) {
        double price = item['custom_price']?.toDouble() ??
            item['base_price']?.toDouble() ??
            0.0;
        int quantity = item['quantity'] ?? 1;
        total += price * quantity;
      }
    }

    // Apply discounts
    final discounts = discovery['discounts'] ?? {};
    double discountRate =
        double.tryParse(discounts['rate']?.toString() ?? '0') ?? 0.0;
    double discountAmount =
        double.tryParse(discounts['amount']?.toString() ?? '0') ?? 0.0;

    if (discountRate > 0) {
      total -= (total * (discountRate / 100));
    }
    if (discountAmount > 0) {
      total -= discountAmount;
    }

    return total;
  }

  // Add this method to DiscoveryController class
  Future<String?> getShareUrl(int discoveryId) async {
    try {
      var storedToken = box.read('token');
      if (storedToken == null) {
        Get.snackbar(
          'Error',
          'Not authenticated',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      final response = await http.get(
        Uri.parse('$url/discoveries/$discoveryId/share'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final shareUrl = jsonResponse['data']['share_url'];
        print(shareUrl);

        // Copy to clipboard
        await Clipboard.setData(ClipboardData(text: shareUrl));

        Get.snackbar(
          'Success',
          'Share URL copied to clipboard',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        return shareUrl;
      } else {
        Get.snackbar(
          'Error',
          'Failed to get share URL',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Error getting share URL: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting share URL',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }
}
