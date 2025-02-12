import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/item_controller.dart';
import 'item_list_widget.dart';

class AddItemWidget extends StatelessWidget {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final ItemController itemController = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          TextField(
            controller: itemNameController,
            decoration: InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: brandController,
            decoration: InputDecoration(
              labelText: 'Brand',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await itemController.storeItem(
                item: itemNameController.text.trim(),
                brand: brandController.text.trim(),
                price: priceController.text.trim(),
              );

              // Clear the text fields after submission
              itemNameController.clear();
              brandController.clear();
              priceController.clear();
            },
            child: Obx(() {
              return itemController.isLoading.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Add Item',
                      style: TextStyle(fontSize: 18),
                    );
            }),
          ),
          SizedBox(height: 30),
          ItemListWidget(
            itemController: itemController,
            onEditItem: (item) {
              itemNameController.text = item['item'];
              brandController.text = item['brand'];
              priceController.text = item['price'].toString();
            },
          ),
        ],
      ),
    );
  }
}
