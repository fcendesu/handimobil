import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/item_controller.dart';
import '../../controllers/discovery_controller.dart';
import '../../models/selected_item.dart';

class ItemSelectorWidget extends StatelessWidget {
  final ItemController itemController = Get.find();
  final DiscoveryController discoveryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Items',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            itemController.searchText.value = value;
            itemController.searchItems(value);
          },
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Obx(() {
            if (itemController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: itemController.items.length,
              itemBuilder: (context, index) {
                final item = itemController.items[index];
                return ListTile(
                  title: Text(item['item']),
                  subtitle:
                      Text('Brand: ${item['brand']}, Price: ${item['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showQuantityDialog(context, item);
                    },
                  ),
                );
              },
            );
          }),
        ),
        SizedBox(height: 16),
        Obx(() => Column(
              children: discoveryController.selectedItems
                  .map((item) => Card(
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            'Quantity: ${item.quantity}\n'
                            'Price: ${item.customPrice ?? item.originalPrice}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                discoveryController.removeItem(item.id),
                          ),
                        ),
                      ))
                  .toList(),
            )),
      ],
    );
  }

  void _showQuantityDialog(BuildContext context, Map<String, dynamic> item) {
    final quantityController = TextEditingController(text: '1');
    final customPriceController = TextEditingController();
    bool useCustomPrice = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add ${item['item']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Checkbox(
                    value: useCustomPrice,
                    onChanged: (value) {
                      setState(() => useCustomPrice = value!);
                    },
                  ),
                  Text('Use custom price'),
                ],
              ),
              if (useCustomPrice)
                TextField(
                  controller: customPriceController,
                  decoration: InputDecoration(labelText: 'Custom Price'),
                  keyboardType: TextInputType.number,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                discoveryController.addItem(SelectedItem(
                  id: item['id'],
                  name: item['item'],
                  brand: item['brand'],
                  originalPrice: double.parse(item['price'].toString()),
                  quantity: int.parse(quantityController.text),
                  customPrice:
                      useCustomPrice && customPriceController.text.isNotEmpty
                          ? double.parse(customPriceController.text)
                          : null,
                ));
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
