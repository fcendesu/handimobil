import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/item_controller.dart';
import '../../controllers/discovery_controller.dart';
import '../../models/selected_item.dart';

class ItemSelectorWidget extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());
  final DiscoveryController discoveryController = Get.find();

  ItemSelectorWidget({super.key});

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
    var useCustomPrice = false.obs;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${item['item']}'),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: useCustomPrice.value,
                      onChanged: (value) => useCustomPrice.value = value!,
                    ),
                    const Text('Use custom price'),
                  ],
                ),
                if (useCustomPrice.value) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: customPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ],
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate quantity
              if (quantityController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter a quantity',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final quantity = int.tryParse(quantityController.text);
              if (quantity == null || quantity < 1) {
                Get.snackbar(
                  'Error',
                  'Please enter a valid quantity',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              // Validate custom price if enabled
              double? customPrice;
              if (useCustomPrice.value &&
                  customPriceController.text.isNotEmpty) {
                customPrice = double.tryParse(customPriceController.text);
                if (customPrice == null || customPrice < 0) {
                  Get.snackbar(
                    'Error',
                    'Please enter a valid price',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
              }

              discoveryController.addItem(SelectedItem(
                id: item['id'],
                name: item['item'],
                brand: item['brand'],
                originalPrice: double.parse(item['price'].toString()),
                quantity: quantity,
                customPrice: customPrice,
              ));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
