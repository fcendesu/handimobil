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
              labelText: 'Malzeme Adı',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: brandController,
            decoration: InputDecoration(
              labelText: 'Marka',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Fiyat',
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
                      'Malzeme Ekle',
                      style: TextStyle(fontSize: 18),
                    );
            }),
          ),
          SizedBox(height: 30),
          TextField(
            decoration: InputDecoration(
              labelText: 'Ara...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              itemController.searchText.value = value;
              itemController.searchItems(value);
            },
          ),
          SizedBox(height: 20),
          ItemListWidget(
            itemController: itemController,
          ),
        ],
      ),
    );
  }
}
